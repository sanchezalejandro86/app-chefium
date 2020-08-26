import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/screens/crear_receta_screen.dart';
import 'package:chefium/screens/filtros_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/screens/receta_screen.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/widgets/anuncio_horizontal.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/horizontal_receta.dart';
import 'package:chefium/widgets/infinite_list_view.dart';
import 'package:chefium/widgets/recetas_vacio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class BusquedaScreen extends StatefulWidget {
  final Filtro filtro;
  BusquedaScreen({Key key, @required this.filtro}) : super(key: key);

  @override
  _BusquedaScreenState createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  static const int anunciosCada = 3;
  static const int itemsPorQuery = 6;
  static const _nativeAdUnitID = "ca-app-pub-2156723921552024/8509289720";

  RecetaService _recetaService = RecetaService();
  int _pagina = 1;
  bool _tieneSiguiente = true;
  Future<List<Receta>> _recetasFuture;
  List<Receta> _recetas;

  @override
  void initState() {
    super.initState();
    _recetas = [];
    _tieneSiguiente = true;
    _recetasFuture = _getMasRecetas(_pagina);
  }

  Future<List<Receta>> _getMasRecetas(int pagina) async {
    try {
      Paginacion paginacion = await _recetaService
          .obtenerBusqueda(widget.filtro.toQuery(itemsPorQuery, pagina));
      List<Receta> nuevasRecetas = Receta.fromJsonList(paginacion.docs);
      setState(() {
        if (pagina == 1) {
          _recetas = [];
        }
        _recetas += nuevasRecetas;
        _tieneSiguiente = paginacion.tieneSiguiente;
        _pagina = pagina + 1;
      });
      return _recetas;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            widget.filtro.soloSeguidos = false;
            Navigator.pop(context, widget.filtro);
          },
          icon: Icon(
            ChefiumIcons.cross,
            size: 20,
          ),
        ),
        title: TextField(
          controller: TextEditingController(text: widget.filtro.busqueda),
          onTap: () {
            widget.filtro.soloSeguidos = false;
            Navigator.pop(context, widget.filtro);
          },
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Buscar...',
            border: UnderlineInputBorder(),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _recetasFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          } else {
            if (snapshot.hasData) {
              if (_recetas.length > 0) {
                return InfiniteListView<Receta>(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.filtro.toList().length > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text("Mostrando resultados para",
                                  style: Theme.of(context).textTheme.subtitle1),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Tags(
                          itemCount: widget.filtro.toList().length,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 8,
                          spacing: 10,
                          alignment: WrapAlignment.start,
                          itemBuilder: (int i) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: ItemTags(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                index: i,
                                title: widget.filtro.toList()[i],
                                elevation: 0,
                                active: true,
                                color: Theme.of(context).primaryColor,
                                activeColor: Theme.of(context).primaryColor,
                                colorShowDuplicate: Colors.white,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(height: 20),
                    ],
                  ),
                  areItemsTheSame: (a, b) => a.id == b.id,
                  items: _recetas,
                  hasMore: _tieneSiguiente,
                  getMoreItems: () => _getMasRecetas(_pagina),
                  onRefresh: () => _getMasRecetas(1),
                  loadingBuilder: (context) => CargandoIndicator(),
                  itemBuilder: (context, receta, i) {
                    bool esLaUltima = (i + 1) == _recetas.length;
                    bool esMultiplo = (i + 1) % anunciosCada == 0;
                    bool agregarAnuncio = esMultiplo ||
                        (_recetas.length < anunciosCada && esLaUltima);
                    if (agregarAnuncio) {
                      return Column(
                        children: <Widget>[
                          HorizontalReceta(
                            receta: receta,
                          ),
                          AnuncioHorizontal(adUnitID: _nativeAdUnitID),
                        ],
                      );
                    } else {
                      return HorizontalReceta(
                        receta: receta,
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: RecetasVacio(
                    mensaje: "No hay recetas que coincidan con tu búsqueda",
                  ),
                );
              }
            } else {
              return CargandoIndicator();
            }
          }
        },
      ),
    );
  }
}
