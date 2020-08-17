import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

class InfiniteListView<E> extends StatefulWidget {
  final List<E> items;
  final EdgeInsetsGeometry padding;
  final ScrollController scrollController;
  final bool Function(E, E) areItemsTheSame;
  final Future<List<E>> Function() onRefresh;
  final Future<List<E>> Function() getMoreItems;
  final Widget Function(BuildContext, E, int) itemBuilder;
  final Widget Function(BuildContext, E, int) separatorBuilder;
  final Widget Function(BuildContext) loadingBuilder;
  final Widget header;
  final Widget footer;
  final bool shrinkWrap;
  final bool hasMore;
  final ScrollPhysics physics;

  const InfiniteListView(
      {Key key,
      this.items = const [],
      this.padding,
      this.scrollController,
      this.onRefresh,
      this.header,
      this.footer,
      this.hasMore = true,
      this.getMoreItems,
      this.itemBuilder,
      this.separatorBuilder,
      this.shrinkWrap = false,
      this.physics,
      this.loadingBuilder,
      this.areItemsTheSame})
      : super(key: key);

  @override
  _InfiniteListViewState<E> createState() => new _InfiniteListViewState<E>();
}

class _InfiniteListViewState<E> extends State<InfiniteListView<E>>
    with TickerProviderStateMixin {
  bool _loading;
  ScrollController _scrollController;
  int _enoughQueries;
  double _offsetToArmed = 30;

  @override
  void initState() {
    _loading = false;
    _scrollController = widget.scrollController ?? ScrollController();

    _enoughQueries = 1;

    _scrollController.addListener(() async {
      var triggerFetchMoreSize =
          0.9 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        print("addListener");
        _getItems();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEnoughItems();
    });
    super.initState();
  }

  Future<void> _getEnoughItems() async {
    print("_getEnoughItems");
    if (widget.getMoreItems != null) {
      print(_scrollController.position.maxScrollExtent);
      while (
          _scrollController.position.maxScrollExtent <= 0 && widget.hasMore) {
        _enoughQueries++;
        print("_getEnoughItems while");
        await _getItems();
      }
    }
  }

  Future<void> _getItems() async {
    print("_getItems");
    if (widget.getMoreItems != null) {
      if (widget.hasMore) {
        if (!_loading) {
          setState(() {
            _loading = true;
          });
          await widget.getMoreItems();
          setState(() {
            _loading = false;
          });
        } else {
          print("Already getting more items");
        }
      } else {
        print("Not more items");
      }
    }
  }

  Future<void> _refresh() async {
    print("_refresh");
    if (widget.onRefresh != null) {
      await widget.onRefresh();
      print("terminó");
    }

    if (widget.getMoreItems != null) {
      for (var i = 1; i < _enoughQueries; i++) {
        print("getItems after refresh $i");
        await _getItems();
      }
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _offsetToArmed,
      onRefresh: widget.onRefresh != null ? _refresh : null,
      builder: (context, child, controller) => Stack(
        children: <Widget>[
          AnimatedBuilder(
            child: child,
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0.0, _offsetToArmed * controller.value),
                  child: child,
                ),
              );
            },
          ),
          PositionedIndicatorContainer(
            controller: controller,
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: CargandoIndicator(padding: EdgeInsets.zero),
              ),
            ),
          ),
        ],
      ),
      child: ListView.builder(
        controller: widget.scrollController == null
            ? _scrollController
            : ScrollController(),
        physics: widget.scrollController == null
            ? AlwaysScrollableScrollPhysics()
            : ScrollPhysics(),
        shrinkWrap: widget.scrollController != null,
        padding: widget.padding,
        itemBuilder: (context, i) => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.header ?? Container(),
              ImplicitlyAnimatedList<E>(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                items: widget.items,
                areItemsTheSame: (a, b) {
                  if (widget.areItemsTheSame != null) {
                    return widget.areItemsTheSame(a, b);
                  }
                  return a == b;
                },
                itemBuilder: (context, animation, item, i) {
                  Widget itemWidget;
                  Widget separatorWidget;
                  Widget loadingWidget;

                  itemWidget = widget.itemBuilder(context, item, i);

                  if ((i + 1) < widget.items.length &&
                      widget.separatorBuilder != null) {
                    separatorWidget = widget.separatorBuilder(context, item, i);
                  }

                  if ((i + 1) == widget.items.length &&
                      _loading &&
                      widget.loadingBuilder != null) {
                    loadingWidget = widget.loadingBuilder(context) ??
                        CircularProgressIndicator();
                  }

                  return SizeFadeTransition(
                    sizeFraction: 0.3,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: Column(
                      children: <Widget>[
                        itemWidget ?? Container(),
                        separatorWidget ?? Container(),
                        loadingWidget ?? Container(),
                      ],
                    ),
                  );
                },
              ),
              widget.footer ?? Container(),
            ],
          ),
        ),
        itemCount: 1,
      ),
    );
  }
}
