import 'package:cached_network_image/cached_network_image.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/dieta.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/screens/comentarios_screen.dart';
import 'package:chefium/screens/image_view_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/screens/perfil_screen.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/themes/theme.dart';
import 'package:chefium/pages/receta_ingredientes.dart';
import 'package:chefium/pages/receta_pasos.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:chefium/widgets/pull_to_refresh.dart';
import 'package:chefium/widgets/tags_categorias.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flag/flag.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chefium/models/receta.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/widgets/horizontal_receta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecetaScreen extends StatefulWidget {
  final Receta receta;
  RecetaScreen({Key key, @required this.receta}) : super(key: key);

  @override
  _RecetaScreenState createState() => _RecetaScreenState();
}

class _RecetaScreenState extends State<RecetaScreen> {
  static const _admobAppID = "ca-app-pub-3970248402296752~1474737424";
  static const _nativeAdUnitID = "ca-app-pub-3940256099942544/2247696110";
  static const _admobTestDeviceID = "55AD48A9B5B1B1C3AF5FB4A126D60493";

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[_admobTestDeviceID],
    contentUrl: 'https://flutter.io',
    keywords: <String>['chef'],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static const int catidadMasRecetas = 5;

  final NativeAdmobController _adController = NativeAdmobController();
  final UsuarioService _usuarioService = UsuarioService();
  final RecetaService _recetaService = RecetaService();

  bool _estado = false;
  int _cantidad = 0;
  Future<List<Receta>> _masRecetasFuture;
  List<Receta> _masRecetas;
  Receta _recetaCompleta;
  Future<Receta> _recetaCompletaFuture;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: _admobAppID);
    _showAd();
    _recetaCompleta = widget.receta;
    _estado = _recetaCompleta.esFavorita;
    _cantidad = _recetaCompleta.numerofavoritos;
    _recetaCompletaFuture = _getRecetaCompleta();
    _masRecetasFuture = _getMasRecetas(_recetaCompleta.usuario.id);
  }

  void _showAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("recetasAbiertas")) {
      prefs.setInt("recetasAbiertas", 1);
    } else {
      int nuevo = prefs.getInt("recetasAbiertas") + 1;

      if (nuevo >= 5) {
        createInterstitialAd()
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
            anchorOffset: 0.0,
            horizontalCenterOffset: 0.0,
          );
        prefs.setInt("recetasAbiertas", 1);
      } else {
        prefs.setInt("recetasAbiertas", nuevo);
      }
    }
    int actual = prefs.getInt("recetasAbiertas");
    print("Recetas abiertas: $actual");
  }

  _mostrarLikes() {
    if (_recetaCompleta.esMia) {
      return Container();
    } else {
      if (_cantidad != 0) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Icon(
                    _estado ? ChefiumIcons.heart : ChefiumIcons.heart_outlined,
                    color: MainTheme.marronChefium),
              ),
              onTap: () {
                _usuarioService.editarFavoritos(_recetaCompleta.id);
                setState(() {
                  this._estado = !this._estado;
                  if (this._estado) {
                    this._cantidad++;
                  } else {
                    this._cantidad--;
                  }
                });
              },
              radius: 10,
              borderRadius: BorderRadius.circular(50),
            ),
            Text(
              NumberFormat.compact().format(_recetaCompleta.numerofavoritos),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(
                      _estado
                          ? ChefiumIcons.heart
                          : ChefiumIcons.heart_outlined,
                      color: MainTheme.marronChefium)),
              onTap: () {
                _usuarioService.editarFavoritos(_recetaCompleta.id);
                setState(() {
                  this._estado = !this._estado;
                  if (this._estado) {
                    this._cantidad++;
                  } else {
                    this._cantidad--;
                  }
                });
              },
              radius: 10,
              borderRadius: BorderRadius.circular(50),
            )
          ],
        );
      }
    }
  }

  Future<Receta> _getRecetaCompleta() async {
    Receta nuevaReceta = await _recetaService.obtenerReceta(_recetaCompleta.id);
    setState(() {
      _recetaCompleta = nuevaReceta;
    });
    return nuevaReceta;
  }

  Future<List<Receta>> _getMasRecetas(int usuarioId) async {
    try {
      Map<String, dynamic> query = {
        'usuario': usuarioId,
        "limite": catidadMasRecetas + 1
      };
      Paginacion paginacion = await _recetaService.obtenerBusqueda(query);
      List<Receta> nuevasRecetas = Receta.fromJsonList(paginacion.docs);
      nuevasRecetas.removeWhere((r) => r.id == _recetaCompleta.id);
      if (nuevasRecetas.length > catidadMasRecetas) {
        return nuevasRecetas.sublist(0, (catidadMasRecetas - 1));
      }
      setState(() {
        _masRecetas = nuevasRecetas;
      });
      return nuevasRecetas;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<Widget> _getDietasIcons(List<Dieta> dietas) {
    List<Widget> iconos = [];
    for (Dieta dieta in dietas) {
      iconos.add(Container(width: 5));
      if (dieta.icono != null) {
        iconos.add(Tooltip(
          message: dieta.descripcion ?? "",
          child: SvgPicture.network(
            dieta.icono,
            color: Colors.grey[700],
            semanticsLabel: dieta.descripcion,
          ),
        ));
      }
    }
    return iconos;
  }

  Future<void> _onRefresh() async {
    await _getRecetaCompleta();
    await _getMasRecetas(_recetaCompleta.usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PullToRefresh(
        onRefresh: () => _onRefresh(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _recetaCompleta.foto ?? "",
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageViewScreen(imagen: imageProvider),
                          ),
                        );
                        await _onRefresh();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(ChefiumIcons.photo),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(ChefiumIcons.photo),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: IconButton(
                          icon: Icon(
                            ChefiumIcons.left_arrow,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height * 0.4) - 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _recetaCompleta.titulo,
                                  style: Theme.of(context).textTheme.headline2,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              _mostrarLikes()
                            ],
                          ),
                          Container(height: 10),
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilScreen(
                                    usuario: _recetaCompleta.usuario,
                                  ),
                                ),
                              );
                              await _onRefresh();
                            },
                            child: Row(
                              children: <Widget>[
                                CircularProfileAvatar(
                                  _recetaCompleta.usuario.foto ?? "",
                                  radius: 15,
                                  backgroundColor: Colors.transparent,
                                  initialsText: Text(
                                    "${_recetaCompleta.usuario.iniciales}",
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Por ${_recetaCompleta.usuario.nombreCompleto}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        timeago.format(_recetaCompleta.creacion,
                                            locale: 'es'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 20),
                          TagsCategorias(
                            soloLectura: true,
                            categorias: _recetaCompleta.categorias,
                          ),
                          Container(height: 10),
                          Divider(),
                          Container(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      _recetaCompleta.comentarios?.length
                                              ?.toString() ??
                                          "0",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Text(
                                      "comentarios",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: Color(0xFFf2f5f7),
                                thickness: 1,
                                width: 4,
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      _recetaCompleta.porciones != null
                                          ? _recetaCompleta.porciones.toString()
                                          : "?",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Text(
                                      "porciones",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: Color(0xFFf2f5f7),
                                thickness: 1,
                                width: 4,
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      _recetaCompleta.tiempo.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Text(
                                      'minutos',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(height: 10),
                          Divider(),
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComentariosScreen(
                                    receta: _recetaCompleta,
                                  ),
                                ),
                              );
                              await _onRefresh();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Ver comentarios',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _recetaCompleta.dietas != null &&
                                  _recetaCompleta.dietas.isNotEmpty
                              ? Column(
                                  children: <Widget>[
                                    Divider(),
                                    Container(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Dietas',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          children: _getDietasIcons(
                                              _recetaCompleta.dietas),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          Container(height: 10),
                          _recetaCompleta.origen != null
                              ? Column(
                                  children: <Widget>[
                                    Divider(),
                                    InkWell(
                                      onTap: () async {
                                        Usuario usuario = await _usuarioService
                                            .obtenerUsuarioLocal();
                                        Filtro filtro = Filtro.empty();
                                        filtro.origenes = [
                                          _recetaCompleta.origen
                                        ];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                                filtro: filtro,
                                                tabInicial: 2,
                                                usuario: usuario),
                                          ),
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BusquedaScreen(filtro: filtro),
                                          ),
                                        );
                                        await _onRefresh();
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Origen',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                _recetaCompleta
                                                            .origen.paisISO !=
                                                        null
                                                    ? Flag(
                                                        _recetaCompleta
                                                            .origen.paisISO,
                                                        height: 23,
                                                        width: 23,
                                                      )
                                                    : Container(),
                                                Container(width: 10),
                                                Text(
                                                  _recetaCompleta.origen
                                                          ?.descripcion ??
                                                      "Sin origen",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            height: 200,
                            width: double.infinity,
                            child: NativeAdmob(
                              controller: _adController,
                              adUnitID: _nativeAdUnitID,
                              loading: CargandoIndicator(),
                              error: Center(
                                  child: Text("No se pudo cargar el anuncio")),
                              type: NativeAdmobType.full,
                              options: NativeAdmobOptions(
                                ratingColor: Theme.of(context).primaryColor,
                                headlineTextStyle: NativeTextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                callToActionStyle: NativeTextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          _recetaCompleta.descripcion != null &&
                                  _recetaCompleta.descripcion.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(height: 10),
                                    Text(
                                      _recetaCompleta.descripcion,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Container(height: 20),
                                    Divider(),
                                  ],
                                )
                              : Container(),
                          Container(height: 10),
                          FutureBuilder(
                            future: _recetaCompletaFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error"),
                                );
                              } else {
                                if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Ingredientes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      Container(height: 10),
                                      RecetaIngredientes(
                                        ingredientes:
                                            _recetaCompleta.ingredientes,
                                      ),
                                      Container(height: 20),
                                      Divider(),
                                      Container(height: 10),
                                      Text(
                                        'Paso a Paso',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      RecetaPasos(pasos: _recetaCompleta.pasos),
                                      Container(height: 20),
                                      _recetaCompleta.tips != null &&
                                              _recetaCompleta.tips.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Divider(),
                                                Container(height: 10),
                                                Text(
                                                  '¡Para un mejor resultado!',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                                Container(height: 10),
                                                Text(
                                                  _recetaCompleta.tips,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color: MainTheme.gris,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Container(height: 20),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  );
                                } else {
                                  return CargandoIndicator(
                                      padding: EdgeInsets.all(30));
                                }
                              }
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom,
                            ),
                            child: FutureBuilder(
                              future: _masRecetasFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        "No se pudieron cargar más recetas"),
                                  );
                                } else {
                                  if (snapshot.hasData) {
                                    if (_masRecetas != null &&
                                        _masRecetas.length > 0) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Divider(),
                                          Container(height: 10),
                                          Text(
                                            "Más Delicias de la Mano de ${_recetaCompleta.usuario.nombres != null && _recetaCompleta.usuario.nombres.isNotEmpty ? _recetaCompleta.usuario.nombres : 'NN'}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          Container(height: 10),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemCount: _masRecetas.length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              Receta receta = _masRecetas[i];
                                              return HorizontalReceta(
                                                receta: receta,
                                              );
                                            },
                                          ),
                                          Container(height: 20),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return CargandoIndicator(
                                        padding: EdgeInsets.all(30));
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
