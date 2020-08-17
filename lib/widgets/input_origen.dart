import 'package:chefium/models/origen.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputOrigen extends StatefulWidget {
  final Function(Origen) onChanged;
  final Origen inicial;
  final bool ignoreBlank;
  final List<Origen> listaOrigen;
  InputOrigen(
      {Key key,
      this.onChanged,
      this.inicial,
      @required this.listaOrigen,
      this.ignoreBlank = false})
      : super(key: key);

  @override
  _InputOrigenState createState() => _InputOrigenState();
}

class _InputOrigenState extends State<InputOrigen> {
  Origen _seleccionado;

  @override
  void initState() {
    super.initState();
    _seleccionado = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: TextEditingController(
            text: _seleccionado != null ? _seleccionado.descripcion : ""),
        readOnly: true,
        validator: (valor) {
          if (!widget.ignoreBlank) {
            if (_seleccionado == null) return "No puede estar vacío";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Selecciona un origen",
          prefixIcon: _seleccionado != null && _seleccionado.paisISO != null
              ? Container(
                  padding: EdgeInsets.all(10),
                  child: Flag(
                    _seleccionado.paisISO,
                    height: 10,
                    width: 10,
                  ),
                )
              : null,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Wrap(
              children: <Widget>[
                Container(
                  height: 300,
                  child: Dialogo(
                    opciones: widget.listaOrigen,
                    inicial: _seleccionado,
                    onChanged: (origen) {
                      setState(() {
                        _seleccionado = origen;
                      });

                      widget.onChanged(origen);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Dialogo extends StatefulWidget {
  final Function(Origen) onChanged;
  final Origen inicial;
  final List<Origen> opciones;

  const Dialogo({this.onChanged, this.inicial, @required this.opciones});

  @override
  State createState() => new _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  Origen _seleccionado;

  @override
  void initState() {
    super.initState();
    _seleccionado = widget.inicial;
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Selecciona un origen",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(height: 15),
        Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.opciones.length,
                    itemBuilder: (context, i) => RadioListTile<int>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      groupValue: widget.opciones[i].id,
                      title: Text(widget.opciones[i].descripcion),
                      secondary: Flag(
                        widget.opciones[i].paisISO,
                        height: 23,
                        width: 23,
                      ),
                      value: _seleccionado != null ? _seleccionado.id : null,
                      onChanged: (origenId) {
                        setState(() {
                          _seleccionado = widget.opciones[i];
                        });
                        widget.onChanged(widget.opciones[i]);
                      },
                    ),
                  ),
                ),
                Container(height: 10 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
