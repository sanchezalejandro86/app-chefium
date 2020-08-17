import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformacionScreen extends StatefulWidget {
  final String tipo;
  InformacionScreen({Key key, @required this.tipo}) : super(key: key);

  @override
  _InformacionScreenState createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  String terminos =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent et tempor urna. Duis euismod, justo eu consequat dignissim, dolor nulla scelerisque purus, eu congue libero nibh blandit dui. Vivamus luctus quam nulla, et sollicitudin massa feugiat et. Donec id tempor erat, sit amet interdum risus. Donec a varius lacus. Praesent vestibulum purus id viverra facilisis. Sed sed sem ut dolor bibendum imperdiet. Vivamus facilisis lorem ut facilisis dapibus.';
  String politicas =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam maximus scelerisque vulputate. Aliquam sed molestie urna. Nullam consectetur ante auctor metus porta, id laoreet diam facilisis. Aenean ut tempor quam. Fusce suscipit justo in lorem dapibus, a semper ligula posuere. Fusce non rutrum nibh, sed lobortis mi. Aliquam in orci ipsum. Morbi quis arcu at nisi bibendum blandit. Quisque venenatis odio vel lorem tincidunt, nec placerat velit sollicitudin. Nulla facilisi. Vivamus ac facilisis purus. Donec eget pharetra dolor, vitae tristique sapien. Donec luctus pharetra diam ac eleifend. Integer quis viverra nunc, sed lacinia lectus. Ut sed volutpat nibh. Nullam maximus finibus volutpat. Nam id odio ultricies sem vulputate tincidunt. Ut blandit justo id iaculis ullamcorper. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras consequat volutpat enim sit amet suscipit. Nam porta id libero sed mattis. Maecenas porta, ligula quis tristique volutpat, turpis metus dictum velit, id pulvinar augue metus eget metus. Integer ac urna ex. Nunc quis dolor consequat, fermentum orci non, auctor sapien. Ut eu enim laoreet, molestie mauris eu, bibendum purus. Ut pharetra velit vel laoreet eleifend. Vivamus tincidunt mi interdum, tempor eros eu, porta nibh. Proin interdum dui et ultricies dapibus. Quisque vitae purus sed ligula condimentum vulputate. Pellentesque consectetur id nibh ac auctor. Maecenas vel libero eget erat rhoncus vulputate. Sed quis lacus turpis. Donec et neque lectus. Curabitur eu aliquam mi. Integer risus magna, porta et justo ac, volutpat ullamcorper neque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis mattis nunc ut tortor cursus, ac varius nisl convallis. Maecenas ullamcorper interdum quam eget varius. Nullam venenatis pretium tincidunt. Aenean congue malesuada interdum. Morbi convallis a ipsum in accumsan. Mauris luctus augue a accumsan gravida. Sed vel finibus metus. Sed quis lacus turpis. Donec et neque lectus. Curabitur eu aliquam mi. Integer risus magna, porta et justo ac, volutpat ullamcorper neque. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis mattis nunc ut tortor cursus, ac varius nisl convallis. Maecenas ullamcorper interdum quam eget varius. Nullam venenatis pretium tincidunt. Aenean congue malesuada interdum. Morbi convallis a ipsum in accumsan. Mauris luctus augue a accumsan gravida. Sed vel finibus metus.";
  String acerca =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent et tempor urna. Duis euismod, justo eu consequat dignissim, dolor nulla scelerisque purus, eu congue libero nibh blandit dui. Vivamus luctus quam nulla, et sollicitudin massa feugiat et. Donec id tempor erat, sit amet interdum risus. Donec a varius lacus. Praesent vestibulum purus id viverra facilisis. Sed sed sem ut dolor bibendum imperdiet. Vivamus facilisis lorem ut facilisis dapibus.';

  String _texto() {
    if (widget.tipo.toLowerCase() == 'términos y condiciones') {
      return terminos;
    }
    if (widget.tipo.toLowerCase() == 'políticas de privacidad') {
      return politicas;
    }
    return acerca;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tipo,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
          child: Column(
            children: <Widget>[
              Text(
                widget.tipo,
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _texto(),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
