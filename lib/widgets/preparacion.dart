import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/widgets/input_ingrediente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Preparacion extends StatefulWidget {
  final Function(Map<String, int>) onChanged;
  final Map<String, int> inicial;
  Preparacion({Key key, this.onChanged, this.inicial}) : super(key: key);

  @override
  _PreparacionState createState() => _PreparacionState();
}

class _PreparacionState extends State<Preparacion> {
  int _porciones;
  int _tiempo;

  TextEditingController _porcionesController;
  TextEditingController _tiempoController;

  @override
  void initState() {
    super.initState();
    _porciones = widget.inicial != null ? widget.inicial["porciones"] : null;
    _tiempo = widget.inicial != null ? widget.inicial["tiempo"] : null;
    _porcionesController = TextEditingController(
        text: _porciones != null ? _porciones.toString() : "");
    _tiempoController =
        TextEditingController(text: _tiempo != null ? _tiempo.toString() : "");
  }

  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _porcionesController,
            keyboardType: TextInputType.number,
            validator: (valor) {
              if (valor.isEmpty) return "No puede estar vacío";
              if (int.parse(valor) == null) return "Debe ser numérico";
              return null;
            },
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (String porciones) {
              _porciones = int.parse(porciones);
              widget.onChanged({
                'porciones': _porciones,
                'tiempo': _tiempo,
              });
            },
            decoration: InputDecoration(
              labelText: 'Porciones',
            ),
          ),
        ),
        Container(width: 10),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _tiempoController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            validator: (valor) {
              if (valor.isEmpty) return "No puede estar vacío";
              if (int.parse(valor) == null) return "Debe ser numérico";
              return null;
            },
            onChanged: (String tiempo) {
              _tiempo = int.parse(tiempo);
              widget.onChanged({
                'porciones': _porciones,
                'tiempo': _tiempo,
              });
            },
            decoration: InputDecoration(
              labelText: 'Minutos preparación',
            ),
          ),
        ),
      ],
    );
  }
}
