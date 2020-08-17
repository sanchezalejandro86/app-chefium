import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/themes/theme.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/horizontal_receta.dart';
import 'package:chefium/widgets/infinite_list_view.dart';
import 'package:chefium/widgets/recetas_vacio.dart';
import 'package:chefium/widgets/square_receta.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int cantidadFavoritas = 3;
  static const int cantidadRecientes = 5;
  static const int itemsPorQuery = 6;

  RecetaService _recetaService = new RecetaService();
  UsuarioService _usuarioService = new UsuarioService();

  ScrollController _scrollController = ScrollController();

  int _pagina = 1;
  bool _tieneSiguiente = true;
  Future<List<Receta>> _recientesFuture;
  Future<List<Receta>> _favoritasFuture;
  Future<List<Receta>> _recetasFuture;
  List<Receta> _recientes;
  List<Receta> _favoritas;
  List<Receta> _recetas;

  Future<List<Receta>> _getRecetasRecientes() async {
    try {
      Map<String, dynamic> query = {
        'ordenar': '-creacion',
        "limite": cantidadRecientes
      };
      Paginacion paginacion = await _recetaService.obtenerBusqueda(query);
      List<Receta> nuevasRecetas = Receta.fromJsonList(paginacion.docs);
      setState(() {
        _recientes = nuevasRecetas;
      });
      return nuevasRecetas;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Receta>> _getRecetasFavoritas() async {
    try {
      Map<String, dynamic> query = {
        "ordenar": '-numeroFavoritos',
        "limite": cantidadFavoritas
      };
      Paginacion paginacion = await _recetaService.obtenerBusqueda(query);
      List<Receta> nuevasRecetas = Receta.fromJsonList(paginacion.docs);
      setState(() {
        _favoritas = nuevasRecetas;
      });
      return nuevasRecetas;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Receta>> _getRecetas(int pagina) async {
    try {
      Map<String, dynamic> query = {
        'ordenar': '-creacion',
        "limite": cantidadRecientes,
        "pagina": pagina,
        "soloSeguidos": true,
      };
      Paginacion paginacion = await _recetaService.obtenerBusqueda(query);
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
  void initState() {
    super.initState();
    _recientesFuture = _getRecetasRecientes();
    _favoritasFuture = _getRecetasFavoritas();
    _recetasFuture = _getRecetas(_pagina);
  }

  Future<void> _onRefresh() async {
    await _getRecetasRecientes();
    await _getRecetasFavoritas();
    await _getRecetas(1);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: AssetImage('lib/assets/images/home.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Cociná con lo que tenés",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: MainTheme.amarilloChefium),
                    ),
                    Text(
                      "Buscá la receta ideal para tus ingredientes",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: MainTheme.amarilloChefium,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(height: 20),
                    FlatButton(
                      child: Text(
                        'Ver más',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      padding: EdgeInsets.fromLTRB(27, 6, 27, 6),
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {
                        Usuario usuario =
                            await _usuarioService.obtenerUsuarioLocal();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainScreen(tabInicial: 2, usuario: usuario),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 30),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Preferidas de la gente',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Usuario usuario =
                          await _usuarioService.obtenerUsuarioLocal();

                      Filtro filtro = Filtro.empty();
                      filtro.ordenCampo = ["numeroFavoritos"];
                      filtro.ordenAscendente = [false];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                              filtro: filtro, tabInicial: 2, usuario: usuario),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusquedaScreen(filtro: filtro),
                        ),
                      );
                    },
                    child: Text(
                      'Ver todos',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              )),
          FutureBuilder(
            future: _favoritasFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              } else {
                if (snapshot.hasData) {
                  if (_favoritas.length > 0) {
                    return Container(
                      height: 241,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount:
                            _favoritas.length > 5 ? 5 : snapshot.data.length,
                        itemBuilder: (BuildContext context, int i) {
                          Receta receta = snapshot.data[i];
                          return SquareReceta(receta: receta);
                        },
                      ),
                    );
                  } else {
                    return RecetasVacio(
                      mensaje:
                          "Aún no hay recetas creadas, ¿qué te parece crear una?",
                      action: RaisedButton(
                        child: Text("Crear receta"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {
                          Usuario usuario =
                              await _usuarioService.obtenerUsuarioLocal();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(tabInicial: 1, usuario: usuario),
                            ),
                          );
                        },
                        textColor: Colors.white,
                        elevation: 0,
                        disabledElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                } else {
                  return CargandoIndicator(padding: EdgeInsets.all(30));
                }
              }
            },
          ),
          Container(height: 20),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Más recientes',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Usuario usuario =
                          await _usuarioService.obtenerUsuarioLocal();
                      Filtro filtro = Filtro.empty();
                      filtro.ordenCampo = ["creacion"];
                      filtro.ordenAscendente = [false];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                              filtro: filtro, tabInicial: 2, usuario: usuario),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusquedaScreen(filtro: filtro),
                        ),
                      );
                    },
                    child: Text(
                      'Ver todos',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              )),
          Container(
            height: 241,
            child: FutureBuilder(
              future: _recientesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (_recientes.length > 0) {
                      return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int i) {
                          Receta receta = snapshot.data[i];
                          return SquareReceta(receta: receta);
                        },
                      );
                    } else {
                      return RecetasVacio(
                        mensaje:
                            "Aún no hay recetas creadas, ¿qué te parece crear una?",
                        action: RaisedButton(
                          child: Text("Crear receta"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () async {
                            Usuario usuario =
                                await _usuarioService.obtenerUsuarioLocal();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainScreen(tabInicial: 1, usuario: usuario),
                              ),
                            );
                          },
                          textColor: Colors.white,
                          elevation: 0,
                          disabledElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverElevation: 0,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  } else {
                    return CargandoIndicator(padding: EdgeInsets.all(30));
                  }
                }
              },
            ),
          ),
          FutureBuilder(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      header: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Personas que sigues',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      areItemsTheSame: (a, b) => a.id == b.id,
                      items: _recetas,
                      shrinkWrap: true,
                      scrollController: _scrollController,
                      physics: ScrollPhysics(),
                      hasMore: _tieneSiguiente,
                      getMoreItems: () => _getRecetas(_pagina),
                      onRefresh: () => _onRefresh(),
                      loadingBuilder: (context) => CargandoIndicator(),
                      itemBuilder: (context, receta, i) => HorizontalReceta(
                        receta: receta,
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return CargandoIndicator();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
