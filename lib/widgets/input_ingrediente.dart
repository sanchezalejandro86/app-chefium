import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputIngrediente extends StatefulWidget {
  final Function onChanged;
  final Function(String) validator;
  final Ingrediente inicial;
  final List<Ingrediente> listaIngrediente;
  InputIngrediente(
      {Key key,
      Function this.onChanged,
      this.listaIngrediente,
      this.validator,
      this.inicial})
      : super(key: key);

  @override
  _InputIngredienteState createState() => _InputIngredienteState();
}

class _InputIngredienteState extends State<InputIngrediente> {
  GlobalKey<AutoCompleteTextFieldState<Ingrediente>> _autoKey = new GlobalKey();
  TextEditingController _ingredienteController = TextEditingController();
  Ingrediente _ingredienteSeleccionado;

  @override
  void initState() {
    super.initState();
    _ingredienteController.text = widget.inicial?.nombre ?? "";
    _ingredienteSeleccionado = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    return AutoCompleteTextField<Ingrediente>(
      key: _autoKey,
      itemFilter: (ingrediente, query) =>
          ingrediente.nombre.toLowerCase().contains(query.toLowerCase()),
      itemSorter: (a, b) => a.nombre.compareTo(b.nombre),
      itemBuilder: (context, ingrediente) =>
          ListTile(title: Text(ingrediente.nombre)),
      decoration: new InputDecoration(hintText: 'Ej: Tomate'),
      submitOnSuggestionTap: true,
      suggestions: widget.listaIngrediente,
      clearOnSubmit: false,
      controller: _ingredienteController,
      itemSubmitted: (ingrediente) {
        setState(() {
          _ingredienteSeleccionado = ingrediente;
          _autoKey.currentState.controller.text = ingrediente.nombre;
          _autoKey.currentState.updateOverlay();
        });
        print("INPUT");
        print(widget.listaIngrediente[0].id);
        widget.onChanged(ingrediente);
      },
    );
  }
}
