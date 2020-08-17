import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/paso.dart';
import 'package:chefium/widgets/item_paso.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewPaso extends StatefulWidget {
  final Function onChanged;
  final List<Paso> inicial;
  ListViewPaso({Key key, this.onChanged, this.inicial}) : super(key: key);

  @override
  _ListViewPasoState createState() => _ListViewPasoState();
}

class _ListViewPasoState extends State<ListViewPaso> {
  List<Paso> _listaActual;

  @override
  void initState() {
    super.initState();
    _listaActual = widget.inicial ?? [];
  }

  List<Paso> _limpiar(List<Paso> lista) {
    List<Paso> copia = List.from(lista);
    copia.removeWhere((e) => e == null);
    print(copia.length);
    return copia;
  }

  String _validar(List<Paso> lista) {
    List<Paso> limpia = _limpiar(lista);
    for (var p in limpia) {
      if (p.descripcion == null || p.descripcion.isEmpty) {
        return "Debe terminar de escribir todos los pasos antes de crear otro";
      }
    }
    return null;
  }

  int _getPasoByIndex(List<Paso> pasos, int index) {
    int paso = 0;
    for (var i = 0; i <= index; i++) {
      if (pasos[i] != null) {
        paso++;
      }
    }
    return paso;
  }

  Widget _buildItem(Paso paso, int i) {
    if (paso != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Paso ',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Container(width: 5),
                    Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          _getPasoByIndex(_listaActual, i).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ItemPaso(
                  inicial: paso,
                  onChanged: (data) {
                    Paso _nuevoPaso = Paso.empty();
                    _nuevoPaso.fotosEncoded = data['fotos'];
                    _nuevoPaso.descripcion = data['descripcion'];
                    _nuevoPaso.orden = i + 1;

                    setState(() {
                      _listaActual[i] = _nuevoPaso;
                    });

                    widget.onChanged(_limpiar(_listaActual));
                  },
                )
              ],
            ),
          ),
          Container(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                _listaActual[i] = null;
              });
              widget.onChanged(_limpiar(_listaActual));
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
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Paso a paso',
              style: Theme.of(context).textTheme.headline6,
            ),
            InkWell(
              onTap: () {
                String validacion = _validar(_listaActual);
                if (validacion == null) {
                  setState(() {
                    _listaActual.add(Paso.empty());
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
                      borderRadius: BorderRadius.circular(50)),
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
        ListView.separated(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _listaActual.length,
          separatorBuilder: (context, i) => _listaActual[i] != null
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Divider(height: 1),
                )
              : Container(),
          itemBuilder: (context, i) {
            return _buildItem(_listaActual[i], i);
          },
        )
      ],
    );
  }
}
