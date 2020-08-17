import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chefium/models/ingrediente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class SelectorIngredientes extends StatefulWidget {
  final List<Ingrediente> ingredientes;
  final List<Ingrediente> ingredientesIniciales;
  final Function onChanged;

  SelectorIngredientes(
      {Key key,
      @required List<Ingrediente> this.ingredientes,
      List<Ingrediente> this.ingredientesIniciales,
      Function this.onChanged})
      : super(key: key);

  @override
  _SelectorIngredientesState createState() => _SelectorIngredientesState();
}

class _SelectorIngredientesState extends State<SelectorIngredientes> {
  GlobalKey<AutoCompleteTextFieldState<Ingrediente>> _autoKey = new GlobalKey();

  List<Ingrediente> _ingredientesSeleccionados = [];

  List<Ingrediente> _obtenerSugerencias() {
    List<Ingrediente> copiaIngredientes =
        List<Ingrediente>.from(widget.ingredientes);
    List<int> idsSeleccionados =
        _ingredientesSeleccionados.map((e) => e.id).toList();
    copiaIngredientes.removeWhere(
        (ingrediente) => idsSeleccionados.contains(ingrediente.id));
    return copiaIngredientes;
  }

  @override
  void initState() {
    _ingredientesSeleccionados = widget.ingredientesIniciales ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ingredientes.length > 0) {
      return Column(
        children: <Widget>[
          AutoCompleteTextField<Ingrediente>(
            key: _autoKey,
            itemFilter: (ingrediente, query) =>
                ingrediente.nombre.toLowerCase().contains(query.toLowerCase()),
            itemSorter: (a, b) => a.nombre.compareTo(b.nombre),
            itemBuilder: (context, ingrediente) =>
                ListTile(title: Text(ingrediente.nombre)),
            decoration: new InputDecoration(hintText: 'Ej: Tomate, cebolla'),
            submitOnSuggestionTap: true,
            suggestions: _obtenerSugerencias(),
            clearOnSubmit: true,
            itemSubmitted: (ingrediente) {
              setState(() {
                _ingredientesSeleccionados.add(ingrediente);
              });
              widget.onChanged(_ingredientesSeleccionados);
              _autoKey.currentState.updateSuggestions(_obtenerSugerencias());
            },
          ),
          Container(height: 10),
          Container(
            width: double.infinity,
            child: Tags(
              itemCount: _ingredientesSeleccionados.length,
              verticalDirection: VerticalDirection.up,
              runSpacing: 8,
              spacing: 10,
              alignment: WrapAlignment.start,
              itemBuilder: (int i) {
                return ItemTags(
                  key: Key(_ingredientesSeleccionados[i].id.toString()),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  index: i,
                  title: _ingredientesSeleccionados[i].nombre,
                  pressEnabled: false,
                  elevation: 0,
                  activeColor: Theme.of(context).accentColor,
                  textActiveColor: Colors.white,
                  textColor: Colors.white,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w400),
                  removeButton: ItemTagsRemoveButton(
                    backgroundColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    onRemoved: () {
                      setState(() {
                        _ingredientesSeleccionados.removeAt(i);
                      });
                      widget.onChanged(_ingredientesSeleccionados);
                      _autoKey.currentState
                          .updateSuggestions(_obtenerSugerencias());
                      return true;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
