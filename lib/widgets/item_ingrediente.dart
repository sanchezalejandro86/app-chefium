import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/widgets/input_ingrediente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemIngrediente extends StatefulWidget {
  final Ingrediente inicial;
  final List<Ingrediente> ingredientes;
  final Function(Ingrediente) onChanged;
  ItemIngrediente(
      {Key key, @required this.ingredientes, this.inicial, this.onChanged})
      : super(key: key);

  @override
  _ItemIngredienteState createState() => _ItemIngredienteState();
}

class _ItemIngredienteState extends State<ItemIngrediente> {
  Ingrediente _ingredienteSeleccionado;
  double _cantidad;
  String _medida;

  TextEditingController _cantidadController;
  TextEditingController _medidaController;

  @override
  void initState() {
    super.initState();
    _ingredienteSeleccionado =
        widget.inicial != null ? widget.inicial : Ingrediente.empty();
    _cantidad = widget.inicial != null && widget.inicial.cantidad != null
        ? double.parse(widget.inicial.cantidad.toString())
        : null;
    _medida = widget.inicial != null ? widget.inicial.medida : null;
    _cantidadController = TextEditingController(
        text: widget.inicial != null && widget.inicial.cantidad != null
            ? widget.inicial.cantidad.toString()
            : "");
    _medidaController = TextEditingController(
        text: widget.inicial != null ? widget.inicial.medida : "");
  }

  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextFormField(
            controller: _cantidadController,
            keyboardType: TextInputType.number,
            onChanged: (String cantidad) {
              _cantidad = double.parse(cantidad);
              widget.onChanged(
                Ingrediente(
                  id: _ingredienteSeleccionado.id,
                  cantidad: _cantidad,
                  medida: _medida,
                  nombre: _ingredienteSeleccionado.nombre,
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Cantidad',
            ),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _medidaController,
            onChanged: (String medida) {
              _medida = medida;
              widget.onChanged(
                Ingrediente(
                  id: _ingredienteSeleccionado.id,
                  cantidad: _cantidad,
                  medida: _medida,
                  nombre: _ingredienteSeleccionado.nombre,
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Medida',
            ),
          ),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: InputIngrediente(
            inicial: _ingredienteSeleccionado,
            listaIngrediente: widget.ingredientes,
            onChanged: (nuevoIngrediente) {
              _ingredienteSeleccionado = nuevoIngrediente;
              widget.onChanged(
                Ingrediente(
                  id: nuevoIngrediente.id,
                  cantidad: _cantidad,
                  medida: _medida,
                  nombre: nuevoIngrediente.nombre,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
