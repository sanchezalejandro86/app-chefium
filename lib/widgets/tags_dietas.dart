import 'package:chefium/models/dieta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class TagsDietas extends StatefulWidget {
  final List<Dieta> dietas;
  final List<Dieta> seleccionadasInicial;
  final Function onChanged;
  TagsDietas(
      {Key key,
      @required List<Dieta> this.dietas,
      List<Dieta> this.seleccionadasInicial,
      Function this.onChanged})
      : super(key: key);

  @override
  _TagsDietasState createState() => _TagsDietasState();
}

class _TagsDietasState extends State<TagsDietas> {
  List<Dieta> _dietasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    if (widget.seleccionadasInicial != null) {
      _dietasSeleccionadas = widget.seleccionadasInicial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tags(
      itemCount: widget.dietas.length,
      verticalDirection: VerticalDirection.down,
      runSpacing: 8,
      spacing: 10,
      alignment: WrapAlignment.start,
      itemBuilder: (int i) {
        Dieta dieta = widget.dietas[i];
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
              Dieta cambiada = widget.dietas[item.index];
              if (item.active) {
                _dietasSeleccionadas.add(cambiada);
              } else {
                _dietasSeleccionadas
                    .removeWhere((dieta) => dieta.id == cambiada.id);
              }
              widget.onChanged(_dietasSeleccionadas);
            },
            title: dieta.descripcion,
            customData: dieta.id,
            elevation: 0,
            active:
                _dietasSeleccionadas.indexWhere((d) => d.id == dieta.id) != -1,
            color: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            textActiveColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
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
