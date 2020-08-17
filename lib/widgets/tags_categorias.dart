import 'package:chefium/models/categoria.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class TagsCategorias extends StatefulWidget {
  final List<Categoria> categorias;
  final List<Categoria> seleccionadasInicial;
  final bool soloLectura;
  final Function onChanged;
  TagsCategorias(
      {Key key,
      @required List<Categoria> this.categorias,
      bool this.soloLectura = false,
      List<Categoria> this.seleccionadasInicial,
      Function this.onChanged})
      : super(key: key);

  @override
  _TagsCategoriasState createState() => _TagsCategoriasState();
}

class _TagsCategoriasState extends State<TagsCategorias> {
  List<Categoria> _categoriasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    if (widget.seleccionadasInicial != null) {
      _categoriasSeleccionadas = widget.seleccionadasInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      itemCount: widget.categorias.length,
      verticalDirection: VerticalDirection.down,
      runSpacing: 8,
      spacing: 10,
      alignment: WrapAlignment.start,
      itemBuilder: (int i) {
        Categoria categoria = widget.categorias[i];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: ItemTags(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            index: i,
            onPressed: (item) {
              Categoria cambiada = widget.categorias[item.index];
              if (widget.soloLectura) {
                Filtro filtro = Filtro.empty();
                filtro.categorias = [cambiada];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MainScreen(filtro: filtro, tabInicial: 2),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusquedaScreen(filtro: filtro),
                  ),
                );
              } else {
                if (item.active) {
                  _categoriasSeleccionadas.add(cambiada);
                } else {
                  _categoriasSeleccionadas
                      .removeWhere((categoria) => categoria.id == cambiada.id);
                }
                widget.onChanged(_categoriasSeleccionadas);
              }
            },
            title: categoria.descripcion,
            customData: categoria.id,
            elevation: 0,
            active: widget.soloLectura
                ? true
                : (_categoriasSeleccionadas
                        .indexWhere((c) => c.id == categoria.id) !=
                    -1),
            color: widget.soloLectura
                ? Theme.of(context).primaryColor
                : Colors.white,
            activeColor: Theme.of(context).primaryColor,
            colorShowDuplicate: Colors.blue,
            textColor: widget.soloLectura
                ? Colors.white
                : Theme.of(context).primaryColor,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w400),
          ),
        );
      },
    );
  }
}
