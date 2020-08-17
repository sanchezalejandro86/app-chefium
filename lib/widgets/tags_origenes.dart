import 'package:chefium/models/origen.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class TagsOrigenes extends StatefulWidget {
  final List<Origen> origenes;
  final List<Origen> seleccionadosInicial;
  final Function onChanged;
  TagsOrigenes(
      {Key key,
      @required List<Origen> this.origenes,
      List<Origen> this.seleccionadosInicial,
      Function this.onChanged})
      : super(key: key);

  @override
  _TagsOrigenesState createState() => _TagsOrigenesState();
}

class _TagsOrigenesState extends State<TagsOrigenes> {
  List<Origen> _origenesSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    if (widget.seleccionadosInicial != null) {
      _origenesSeleccionadas = widget.seleccionadosInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      itemCount: widget.origenes.length,
      verticalDirection: VerticalDirection.down,
      runSpacing: 8,
      spacing: 10,
      alignment: WrapAlignment.start,
      itemBuilder: (int i) {
        Origen origen = widget.origenes[i];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: ItemTags(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            index: i,
            onPressed: (item) {
              Origen cambiada = widget.origenes[item.index];
              if (item.active) {
                _origenesSeleccionadas.add(cambiada);
              } else {
                _origenesSeleccionadas
                    .removeWhere((origen) => origen.id == cambiada.id);
              }
              widget.onChanged(_origenesSeleccionadas);
            },
            title: origen.descripcion,
            customData: origen.id,
            image: ItemTagsImage(
              child: Flag(origen.paisISO, height: 15, width: 15),
            ),
            combine: ItemTagsCombine.withTextAfter,
            active:
                _origenesSeleccionadas.indexWhere((o) => o.id == origen.id) !=
                    -1,
            elevation: 0,
            color: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            textActiveColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w400),
          ),
        );
      },
    );
  }
}
