import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/comentario.dart';
import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/crear_cometario_screen.dart';
import 'package:chefium/services/comentario_service.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/comentario_list_tile.dart';
import 'package:chefium/widgets/infinite_list_view.dart';
import 'package:chefium/widgets/recetas_vacio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:chefium/widgets/pull_to_refresh.dart';

class ComentariosScreen extends StatefulWidget {
  final Receta receta;

  ComentariosScreen({Key key, @required this.receta}) : super(key: key);

  @override
  _ComentariosScreenState createState() => new _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  static const int itemsPerQuery = 10;

  ComentarioService _comentarioService = ComentarioService();
  int _pagina = 1;
  bool _tieneSiguiente = true;
  bool _loading = false;
  List<Comentario> _comentarios;
  Future<List<Comentario>> _initialComentarios;
  TextEditingController _searchController;
  ScrollController _scrollController;

  @override
  void initState() {
    _comentarios = [];
    _pagina = 1;
    _loading = false;
    _tieneSiguiente = true;
    _initialComentarios = _getComentarios(_pagina);
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    super.initState();
  }

  Future<List<Comentario>> _getComentarios(int pagina,
      [String busqueda]) async {
    Paginacion paginacion;
    if (busqueda != null && busqueda.isNotEmpty) {
      paginacion = await _comentarioService.obtenerBusqueda({
        "limite": itemsPerQuery,
        "pagina": pagina,
        "busqueda": busqueda,
        "receta": widget.receta.id,
      });
    } else {
      paginacion = await _comentarioService.obtenerBusqueda({
        "limite": itemsPerQuery,
        "pagina": pagina,
        "receta": widget.receta.id,
      });
    }

    List<Comentario> nuevosComentarios =
        Comentario.fromJsonList(paginacion.docs);

    setState(() {
      if (pagina == 1) {
        _comentarios = [];
      }
      _comentarios += nuevosComentarios;
      _tieneSiguiente = paginacion.tieneSiguiente;
      _pagina = pagina + 1;
    });
    return _comentarios;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Comentarios",
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CrearComentarioScreen(receta: widget.receta),
            ),
          );
          await _getComentarios(1, _searchController.text);
        },
      ),
      body: PullToRefresh(
        onRefresh: () => _getComentarios(1, _searchController.text),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      enabled: !_loading,
                      onChanged: (val) async {
                        if (val == null || val.isEmpty) {
                          setState(() {
                            _loading = true;
                            _comentarios = [];
                          });
                          await _getComentarios(1);
                          setState(() {
                            _loading = false;
                          });
                        }
                      },
                      onFieldSubmitted: (val) async {
                        setState(() {
                          _loading = true;
                          _comentarios = [];
                        });
                        await _getComentarios(1, val);
                        setState(() {
                          _loading = false;
                        });
                      },
                      onEditingComplete: () async {
                        setState(() {
                          _loading = true;
                          _comentarios = [];
                        });
                        await _getComentarios(1, _searchController.text);
                        setState(() {
                          _loading = false;
                        });
                      },
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () async {
                            await _getComentarios(1, _searchController.text);
                          },
                          child: Icon(
                            ChefiumIcons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        hintText: "Buscar...",
                      ),
                    ),
                    Container(height: 20),
                    Text(
                      "Resultados",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _initialComentarios,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_comentarios.length > 0) {
                      return InfiniteListView<Comentario>(
                        scrollController: _scrollController,
                        items: _comentarios,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        hasMore: _tieneSiguiente,
                        getMoreItems: () =>
                            _getComentarios(_pagina, _searchController.text),
                        areItemsTheSame: (a, b) => a.id == b.id,
                        separatorBuilder: (context, visit, i) =>
                            Divider(height: 1),
                        loadingBuilder: (context) => CargandoIndicator(),
                        itemBuilder: (context, comentario, i) {
                          return ComentarioListTile(
                            comentario: comentario,
                            mostrarMenu: comentario.esMio,
                            onUpdate: (comentario) async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CrearComentarioScreen(
                                    receta: widget.receta,
                                    comentario: comentario,
                                  ),
                                ),
                              );
                              await _getComentarios(1, _searchController.text);
                            },
                            onDelete: (comentario) async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    CargandoDialog(),
                              );

                              try {
                                bool deleted = await _comentarioService
                                    .eliminarComentario(comentario.id);
                                Navigator.pop(context);

                                setState(() {
                                  _comentarios.removeAt(i);
                                });

                                List<Comentario> updatedComentarios =
                                    await _getComentarios(
                                        1, _searchController.text);

                                setState(() {
                                  _comentarios = updatedComentarios;
                                });
                              } catch (e) {
                                Navigator.pop(context);
                                Flushbar(
                                  message: e,
                                  duration: Duration(seconds: 5),
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                )..show(context);
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.all(30),
                        child: RecetasVacio(
                          mensaje: _searchController.text.isEmpty
                              ? "Aún no hay ningún comentario públicado"
                              : "No hay ningún comentario que coincida con tu búsqueda",
                        ),
                      );
                    }
                  } else {
                    return CargandoIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
