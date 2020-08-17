import 'dart:ui';

import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/widgets/item_ingrediente.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

class ListViewIngrediente extends StatefulWidget {
  final List<Ingrediente> ingredientes;
  final List<Ingrediente> inicial;
  final Function onChanged, onReorderStarted, onReorderFinished;
  ListViewIngrediente(
      {Key key,
      @required this.ingredientes,
      this.onChanged,
      this.inicial,
      this.onReorderStarted,
      this.onReorderFinished})
      : super(key: key);

  @override
  _ListViewIngredienteState createState() => _ListViewIngredienteState();
}

class _ListViewIngredienteState extends State<ListViewIngrediente> {
  final _formIngredientesKey = GlobalKey<FormState>();
  List<Ingrediente> _ingredientesValidos;
  int _itemsCreados = 0;

  @override
  void initState() {
    super.initState();
    _ingredientesValidos = widget.inicial ?? [];
    _itemsCreados = 0;
  }

  List<Ingrediente> _limpiar(List<Ingrediente> lista) {
    List<Ingrediente> copia = List.from(lista);
    copia.removeWhere((e) => e == null);
    print(copia.length);
    return copia;
  }

  String _validar(List<Ingrediente> lista) {
    List<Ingrediente> limpia = _limpiar(lista);
    print(limpia.length);
    for (var i in limpia) {
      if (i.id == null) {
        return "Debe seleccionar un ingrediente de la lista antes de agregar otro";
      } else if ((i.medida == null || i.medida.isEmpty) && i.cantidad == null) {
        return "Debe escribir una medida para cada cantidad antes de agregar otro ingrediente";
      }
    }
    return null;
  }

  Widget _buildItem(Ingrediente ingrediente, int i) {
    if (ingrediente != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ItemIngrediente(
              inicial: ingrediente,
              ingredientes: widget.ingredientes,
              onChanged: (ingrediente) {
                setState(() {
                  _ingredientesValidos[i] = ingrediente;
                });

                widget.onChanged(_limpiar(_ingredientesValidos));
              },
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _ingredientesValidos[i] = null;
              });
              widget.onChanged(_limpiar(_ingredientesValidos));
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                ChefiumIcons.cross,
                size: 15,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Ingredientes',
              style: Theme.of(context).textTheme.headline6,
            ),
            InkWell(
              onTap: () {
                String validacion = _validar(_ingredientesValidos);
                if (validacion == null) {
                  setState(() {
                    _ingredientesValidos.add(Ingrediente.empty());
                    _itemsCreados++;
                  });
                } else {
                  Flushbar(
                    message: validacion,
                    duration: Duration(seconds: 5),
                    flushbarStyle: FlushbarStyle.GROUNDED,
                  )..show(context);
                }
              },
              borderRadius: BorderRadius.circular(25),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    ChefiumIcons.plus,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            )
          ],
        ),
        Form(
          key: _formIngredientesKey,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _ingredientesValidos.length,
            itemBuilder: (context, i) {
              return _buildItem(_ingredientesValidos[i], i);
            },
          ),
        ),
      ],
    );
  }
}
