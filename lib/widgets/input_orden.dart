import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:flutter/material.dart';

class InputOrden extends StatefulWidget {
  final Function onChanged;
  InputOrden({Key key, Function this.onChanged}) : super(key: key);

  @override
  _InputOrdenState createState() => _InputOrdenState();
}

class _InputOrdenState extends State<InputOrden> {
  final List<Map<String, dynamic>> variables = [
    {
      "nombre": 'Favoritos',
      "valor": "numeroFavoritos",
    },
    {
      "nombre": 'Creación',
      "valor": "creacion",
    },
    {
      "nombre": 'Tiempo preparación',
      "valor": "tiempoPreparacionMinutos",
    }
  ];

  final List<Map<String, dynamic>> tiposOrden = [
    {
      "nombre": 'Ascendente',
      "valor": true,
    },
    {
      "nombre": 'Descendente',
      "valor": false,
    }
  ];

  Map<String, dynamic> _variableSeleccionada;
  Map<String, dynamic> _ordenSeleccionado;

  @override
  void initState() {
    super.initState();
    _variableSeleccionada = null;
    _ordenSeleccionado = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: DropdownButtonFormField<Map<String, dynamic>>(
            decoration: InputDecoration(hintText: "Campo"),
            items: variables
                .map(
                  (Map<String, dynamic> variable) =>
                      new DropdownMenuItem<Map<String, dynamic>>(
                    value: variable,
                    child: Text(
                      variable["nombre"],
                    ),
                  ),
                )
                .toList(),
            onChanged: (Map<String, dynamic> nuevaVariable) {
              setState(() {
                _variableSeleccionada = nuevaVariable;
                if (_ordenSeleccionado == null) {
                  _ordenSeleccionado = tiposOrden[0];
                }
              });
              widget.onChanged({
                "campo": _variableSeleccionada["valor"],
                "valor": _ordenSeleccionado["valor"]
              });
            },
            value: _variableSeleccionada,
            icon: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(ChefiumIcons.down_arrow),
            ),
            iconSize: 10,
          ),
        ),
        Container(height: 10),
        Container(
          child: DropdownButtonFormField<Map<String, dynamic>>(
            decoration: InputDecoration(hintText: "Orden"),
            items: tiposOrden
                .map(
                  (Map<String, dynamic> orden) =>
                      new DropdownMenuItem<Map<String, dynamic>>(
                    value: orden,
                    child: Text(
                      orden["nombre"],
                    ),
                  ),
                )
                .toList(),
            onChanged: (Map<String, dynamic> nuevoOrden) {
              setState(() {
                _ordenSeleccionado = nuevoOrden;
              });
              widget.onChanged({
                "campo": _variableSeleccionada["valor"],
                "valor": _ordenSeleccionado["valor"]
              });
            },
            value: _ordenSeleccionado,
            icon: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(ChefiumIcons.down_arrow),
            ),
            iconSize: 10,
          ),
        ),
      ],
    );
  }
}
