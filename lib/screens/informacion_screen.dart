import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformacionScreen extends StatefulWidget {
  final String tipo;
  InformacionScreen({Key key, @required this.tipo}) : super(key: key);

  @override
  _InformacionScreenState createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {

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
                "Chefium",
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                  "version 1.0.0",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400),
              ),
              Container(
                height: 20,
              ),
              Text(
                "Cocina con lo que tienes",
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
