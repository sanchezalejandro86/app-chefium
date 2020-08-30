import 'dart:convert';
import 'dart:io';

import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/screens/configuracion_screen.dart';
import 'package:chefium/screens/crear_receta_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/foto_perfil.dart';
import 'package:chefium/widgets/horizontal_receta.dart';
import 'package:chefium/widgets/infinite_list_view.dart';
import 'package:chefium/widgets/pull_to_refresh.dart';
import 'package:chefium/widgets/recetas_vacio.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_pro/image_editor_pro.dart';
import 'package:image_picker/image_picker.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilScreen extends StatefulWidget {
  final Usuario usuario;

  PerfilScreen({Key key, @required this.usuario}) : super(key: key);

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UsuarioService _usuarioService = UsuarioService();
  RecetaService _recetaService = RecetaService();
  ImagePicker picker = ImagePicker();
  Future<Usuario> _usuarioFuture;
  Usuario _usuario;
  ScrollController _scrollController;

  Future<Usuario> _getUsuario() async {
    try {
      Usuario nuevoUsuario =
          await _usuarioService.obtenerUsuario(widget.usuario.id);
      setState(() {
        _usuario = nuevoUsuario;
      });
      return _usuario;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> _toggleSeguir() async {
    try {
      setState(() {
        _usuario.numeroSeguidores = _usuario.siguiendo
            ? _usuario.numeroSeguidores - 1
            : _usuario.numeroSeguidores + 1;
        _usuario.siguiendo = !_usuario.siguiendo;
      });

      dynamic json = await _usuarioService.toggleSeguir(_usuario.id);

      setState(() {
        _usuario.siguiendo = json["quedoSiguiendo"];
        _usuario.numeroSeguidores = json["nuevoNumeroSeguidoresObjetivo"];
      });
      return json["quedoSiguiendo"];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
    _usuarioFuture = _getUsuario();
    _scrollController = ScrollController();
  }

  _launchURL(String url) async {
    if(!url.startsWith("http://")){
      url = "http://" + url;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Flushbar(
        message: "No se puede abrir la URL",
        duration: Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context);
    }
  }

  bool get _soyYo {
    return _usuario.soyYo != null && _usuario.soyYo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !_soyYo,
        elevation: 0.0,
        title: Text(
          _soyYo ? 'Mi perfil' : "Perfil de ${_usuario.nombreCompleto}",
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
        actions: _soyYo
            ? <Widget>[
                IconButton(
                  icon: Icon(ChefiumIcons.gear),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    Usuario nuevoUsuario = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfiguracionScreen(
                          usuario: _usuario,
                        ),
                      ),
                    );

                    if (nuevoUsuario != null) {
                      setState(() {
                        _usuario = nuevoUsuario;
                      });
                    }
                  },
                )
              ]
            : [],
      ),
      body: DefaultTabController(
        length: 2,
        child: PullToRefresh(
          onRefresh: () => _getUsuario(),
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FotoPerfil(
                                  usuario: _usuario,
                                  editable: _soyYo,
                                  onImagen: (imagen) async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          CargandoDialog(),
                                    );
                                    try {
                                      Usuario nuevoUsuario =
                                          await _usuarioService
                                              .editarUsuario({'foto': imagen});
                                      setState(() {
                                        _usuario = nuevoUsuario;
                                      });
                                      Navigator.pop(context);
                                      Flushbar(
                                        message:
                                            "Foto actualizada correctamente",
                                        duration: Duration(seconds: 5),
                                        flushbarStyle: FlushbarStyle.GROUNDED,
                                      )..show(context);
                                    } catch (e) {
                                      Navigator.pop(context);
                                      Flushbar(
                                        message:
                                            "Ocurrió un error cambiando la foto",
                                        duration: Duration(seconds: 5),
                                        flushbarStyle: FlushbarStyle.GROUNDED,
                                      )..show(context);
                                    }
                                  },
                                ),
                                Container(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${_usuario.nombreCompleto}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(height: 10),
                                      _usuario.biografia != null &&
                                              _usuario.biografia.isNotEmpty
                                          ? Text(
                                              _usuario.biografia ?? "",
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            )
                                          : Container(),
                                      Container(height: 10),
                                      _usuario.enlace != null &&
                                              _usuario.enlace.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                _launchURL(_usuario.enlace);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.link,
                                                      color: Colors.grey),
                                                  Container(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      _usuario.enlace ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 20),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        _usuario?.recetas?.length.toString() ??
                                            "0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        "Recetas",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        _usuario?.numeroSeguidores
                                                ?.toString() ??
                                            "0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        "Seguidores",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        _usuario?.numeroSeguidos?.toString() ??
                                            "0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        "Seguidos",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 20),
                            !_soyYo
                                ? Container(
                                    height: 28,
                                    width: double.infinity,
                                    child: FlatButton(
                                      child: Text(
                                        _usuario.siguiendo != null
                                            ? (_usuario.siguiendo
                                                ? "Dejar de seguir"
                                                : "Seguir")
                                            : "Seguir",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      disabledColor: Colors.grey,
                                      onPressed: () async {
                                        await _toggleSeguir();
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      child: Text(
                        _soyYo ? 'Mis recetas' : "Recetas",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Tab(
                      child: Text(
                        _soyYo ? 'Mis favoritas' : "Favoritas",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _usuarioFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error"),
                        );
                      } else {
                        if (snapshot.hasData) {
                          return TabBarView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: _usuario.recetas.length > 0
                                    ? ImplicitlyAnimatedList<Receta>(
                                        items: _usuario.recetas,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        areItemsTheSame: (a, b) => a.id == b.id,
                                        itemBuilder:
                                            (context, animation, receta, i) {
                                          return HorizontalReceta(
                                            receta: receta,
                                            mostrarMenu: _soyYo,
                                            onUpdate: (receta) async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CrearRecetaScreen(
                                                    inicial: receta,
                                                  ),
                                                ),
                                              );
                                              await _getUsuario();
                                            },
                                            onDelete: (receta) async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) =>
                                                        CargandoDialog(),
                                              );

                                              try {
                                                bool deleted =
                                                    await _recetaService
                                                        .eliminarReceta(
                                                            receta.id);
                                                Navigator.pop(context);

                                                setState(() {
                                                  _usuario.recetas.removeAt(i);
                                                });

                                                await _getUsuario();
                                              } catch (e) {
                                                Navigator.pop(context);
                                                Flushbar(
                                                  message: e,
                                                  duration:
                                                      Duration(seconds: 5),
                                                  flushbarStyle:
                                                      FlushbarStyle.GROUNDED,
                                                )..show(context);
                                              }
                                            },
                                          );
                                        },
                                      )
                                    : SingleChildScrollView(
                                        child: RecetasVacio(
                                          mensaje:
                                              "Aún no has compartido ninguna receta, ��qué te parece crear una?",
                                          action: RaisedButton(
                                            child: Text("Crear receta"),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            onPressed: () async {
                                              Usuario usuario =
                                                  await _usuarioService
                                                      .obtenerUsuarioLocal();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainScreen(
                                                          tabInicial: 1,
                                                          usuario: usuario),
                                                ),
                                              );
                                            },
                                            textColor: Colors.white,
                                            elevation: 0,
                                            disabledElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                            hoverElevation: 0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: _usuario.favoritas.length > 0
                                    ? ListView.builder(
                                        itemCount: _usuario.favoritas.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          Receta receta = _usuario.favoritas[i];
                                          return HorizontalReceta(
                                            receta: receta,
                                          );
                                        },
                                      )
                                    : SingleChildScrollView(
                                        child: RecetasVacio(
                                          mensaje:
                                              "Aún no tienes recetas favoritas",
                                          action: RaisedButton(
                                            child: Text("Ver algunas recetas"),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            onPressed: () async {
                                              Usuario usuario =
                                                  await _usuarioService
                                                      .obtenerUsuarioLocal();
                                              Filtro filtro = Filtro.empty();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainScreen(
                                                          filtro: filtro,
                                                          tabInicial: 2,
                                                          usuario: usuario),
                                                ),
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusquedaScreen(
                                                          filtro: filtro),
                                                ),
                                              );
                                            },
                                            textColor: Colors.white,
                                            elevation: 0,
                                            disabledElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                            hoverElevation: 0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          );
                        } else {
                          return CargandoIndicator();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
