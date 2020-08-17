import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class RecetaIngredientes extends StatefulWidget {
  final List<Ingrediente> ingredientes;
  RecetaIngredientes({Key key, @required this.ingredientes}) : super(key: key);
  @override
  _RecetaIngredientesState createState() => _RecetaIngredientesState();
}

class _RecetaIngredientesState extends State<RecetaIngredientes> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: widget.ingredientes.length,
      itemBuilder: (BuildContext context, int i) {
        Ingrediente ingrediente = widget.ingredientes[i];
        return Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(width: 10),
            Text(
              ingrediente.oracion,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: MainTheme.gris, fontWeight: FontWeight.w400),
            ),
          ],
        );
      },
    );
  }
}
