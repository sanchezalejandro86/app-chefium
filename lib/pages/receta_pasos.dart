import 'package:cached_network_image/cached_network_image.dart';
import 'package:chefium/models/paso.dart';
import 'package:chefium/themes/theme.dart';
import 'package:chefium/widgets/paso_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecetaPasos extends StatefulWidget {
  final List<Paso> pasos;
  RecetaPasos({Key key, @required this.pasos}) : super(key: key);
  @override
  _RecetaPasosState createState() => _RecetaPasosState();
}

class _RecetaPasosState extends State<RecetaPasos> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: widget.pasos.length,
      separatorBuilder: (context, index) => Column(
        children: <Widget>[
          Container(height: 10),
          Divider(indent: 60, endIndent: 60),
          Container(height: 10),
        ],
      ),
      itemBuilder: (BuildContext context, int i) {
        Paso paso = widget.pasos[i];
        return PasoListTile(paso: paso);
      },
    );
  }
}
