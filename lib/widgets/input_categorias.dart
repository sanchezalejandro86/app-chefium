import 'package:chefium/models/categoria.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class InputCategorias extends StatefulWidget {
  final Function(List<Categoria>) onChanged;
  final List<Categoria> inicial;
  final bool ignoreBlank;
  final List<Categoria> listaCategoria;
  InputCategorias(
      {Key key,
      this.onChanged,
      this.inicial,
      @required this.listaCategoria,
      this.ignoreBlank = false})
      : super(key: key);

  @override
  _InputCategoriasState createState() => _InputCategoriasState();
}

class _InputCategoriasState extends State<InputCategorias> {
  List<Categoria> _seleccionadas;

  @override
  void initState() {
    super.initState();
    _seleccionadas = widget.inicial ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Selecciona las categorias",
          ),
          validator: (valor) {
            if (!widget.ignoreBlank) {
              if (_seleccionadas == null || _seleccionadas.isEmpty)
                return "No puede estar vacío";
            }
            return null;
          },
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => Wrap(
                children: <Widget>[
                  Container(
                    height: 300,
                    child: Dialogo(
                      opciones: widget.listaCategoria,
                      inicial: _seleccionadas,
                      onChanged: (List<Categoria> nuevas) {
                        setState(() {
                          _seleccionadas = nuevas;
                        });

                        widget.onChanged(nuevas);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(height: 10),
        Tags(
          itemCount: _seleccionadas != null ? _seleccionadas.length : 0,
          verticalDirection: VerticalDirection.down,
          runSpacing: 8,
          spacing: 10,
          alignment: WrapAlignment.start,
          itemBuilder: (int i) {
            Categoria categoria = _seleccionadas[i];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: ItemTags(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                index: i,
                removeButton: ItemTagsRemoveButton(
                  backgroundColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onRemoved: () {
                    setState(() {
                      _seleccionadas.removeAt(i);
                    });
                    widget.onChanged(_seleccionadas);
                    return true;
                  },
                ),
                pressEnabled: false,
                title: categoria.descripcion,
                customData: categoria.id,
                elevation: 0,
                active: true,
                color: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Dialogo extends StatefulWidget {
  final Function(List<Categoria>) onChanged;
  final List<Categoria> inicial;
  final List<Categoria> opciones;

  const Dialogo({this.onChanged, this.inicial, @required this.opciones});

  @override
  State createState() => new _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  List<Categoria> _seleccionadas;

  @override
  void initState() {
    super.initState();
    _seleccionadas = widget.inicial ?? [];
  }

  bool _getValue(Categoria categoria) {
    for (Categoria c in _seleccionadas) {
      if (c.id == categoria.id) {
        return true;
      }
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Selecciona las categorias",
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.opciones.length,
                    itemBuilder: (context, i) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(widget.opciones[i].descripcion),
                      value: _getValue(widget.opciones[i]),
                      selected: _getValue(widget.opciones[i]),
                      onChanged: (valor) {
                        if (valor) {
                          setState(() {
                            _seleccionadas.add(widget.opciones[i]);
                          });
                        } else {
                          setState(() {
                            _seleccionadas.removeAt(i);
                          });
                        }
                        widget.onChanged(_seleccionadas);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
