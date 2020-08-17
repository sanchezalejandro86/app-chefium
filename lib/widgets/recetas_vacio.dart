import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:flutter/material.dart';

class RecetasVacio extends StatefulWidget {
  final String mensaje;
  final Widget action;
  RecetasVacio({Key key, @required this.mensaje, this.action})
      : super(key: key);

  @override
  _RecetasVacioState createState() => _RecetasVacioState();
}

class _RecetasVacioState extends State<RecetasVacio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        children: <Widget>[
          Icon(
            ChefiumIcons.chef,
            size: 80,
            color: Colors.grey,
          ),
          Container(height: 20),
          Text(
            widget.mensaje ?? "Aún no hay recetas para mostrar",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.grey),
          ),
          widget.action != null ? Container(height: 10) : Container(),
          widget.action ?? Container(),
        ],
      ),
    );
  }
}
