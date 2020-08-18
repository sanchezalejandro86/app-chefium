import 'dart:io' show Platform;
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/informacion_screen.dart';
import 'package:chefium/widgets/cargando_indicator.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/screens/editar_usuario_screen.dart';
import 'package:chefium/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionScreen extends StatefulWidget {
  final Usuario usuario;

  ConfiguracionScreen({Key key, @required this.usuario}) : super(key: key);

  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  UsuarioService _usuarioService = UsuarioService();

  Usuario _usuario;

  FacebookLogin _facebookSignIn = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool googleConectado;
  bool facebookConectado;
  bool appleConectado;

  void obtenerEstados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    googleConectado = prefs.getString('idGoogle') != null;
    facebookConectado = prefs.getString('idFacebook') != null;
    appleConectado = prefs.getString('idApple') != null;
  }

  void _conectarConApple() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        prefs.setString('idApple', result.credential.user);
        setState(() {
          appleConectado = true;
        });

        break;
      case AuthorizationStatus.error:
        print("Ocurrió un error inesperado");
        break;

      case AuthorizationStatus.cancelled:
        print("Cancelado por el _usuario");
        break;
    }
  }

  Future<Null> _conectarConFacebook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        prefs.setString('idFacebook', accessToken.userId);
        setState(() {
          facebookConectado = true;
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Facebook Cancelled Status');
        break;
      case FacebookLoginStatus.error:
        print('Facebook Error Status');
        break;
    }
  }

  void _conectarConGoogle() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      GoogleSignInAccount account = await _googleSignIn.signIn();

      prefs.setString('idGoogle', account.id);
      setState(() {
        googleConectado = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _desconectarGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idGoogle', null);
    setState(() {
      googleConectado = false;
    });
  }

  void _desconectarFacebook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idFacebook', null);
    setState(() {
      facebookConectado = false;
    });
  }

  void _desconectarApple() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idApple', null);
    setState(() {
      appleConectado = false;
    });
  }

  void _cerrarSesion() async {
    try {
      await _googleSignIn.signOut();
      await _facebookSignIn.logOut();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  _mostrarBotonApple() {
    if (Platform.isIOS) {
      return ListTile(
        onTap: () {
          if (appleConectado) {
            if (googleConectado || facebookConectado) {
              _desconectarApple();
            }
          } else {
            _conectarConApple();
          }
        },
        subtitle: Text(appleConectado ? 'Conectado' : 'Desconectado'),
        title: Text(
          'Apple',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.w400, color: MainTheme.gris),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  void _onBackPressed() {
    Navigator.pop(context, _usuario);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.delayed(Duration(microseconds: 1));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Configuración',
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: IconButton(
            icon: Icon(ChefiumIcons.left_arrow),
            onPressed: () {
              _onBackPressed();
            },
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Container(
                  color: Color(0xFFDFDFDF),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      "Cuenta",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: MainTheme.gris),
                    ),
                  )),
              ListTile(
                title: Text(
                  'Cerrar sesión',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('idGoogle', null);
                  prefs.setString('idFacebook', null);
                  prefs.setString('idApple', null);

                  await _usuarioService.logOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Nombres',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                subtitle: Text(
                  "${_usuario.nombres != null ? _usuario.nombres : 'NN'}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.grisClaro),
                ),
                onTap: () async {
                  Usuario nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuarioScreen(
                        tipo: 'nombres',
                        inicial: _usuario.nombres,
                      ),
                    ),
                  );
                  setState(() {
                    _usuario = nuevoUsuario;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Apellidos',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                subtitle: Text(
                  "${_usuario.apellidos != null ? _usuario.apellidos : 'NN'}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.grisClaro),
                ),
                onTap: () async {
                  Usuario nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuarioScreen(
                        tipo: 'apellidos',
                        inicial: _usuario.apellidos,
                      ),
                    ),
                  );
                  setState(() {
                    _usuario = nuevoUsuario;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Correo',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                subtitle: Text(
                  "${_usuario.correo}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.grisClaro),
                ),
                onTap: () async {
                  Usuario nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuarioScreen(
                        tipo: 'correo',
                        inicial: _usuario.correo,
                      ),
                    ),
                  );
                  setState(() {
                    _usuario = nuevoUsuario;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Biografía',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                subtitle: Text(
                  _usuario.biografia ?? "Sin biografía",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w400,
                        color: MainTheme.grisClaro,
                      ),
                ),
                onTap: () async {
                  Usuario nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuarioScreen(
                        tipo: 'biografia',
                        inicial: _usuario.biografia,
                      ),
                    ),
                  );
                  setState(() {
                    _usuario = nuevoUsuario;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Enlace',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                subtitle: Text(
                  _usuario.enlace ?? "Sin enlace",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w400,
                        color: MainTheme.grisClaro,
                      ),
                ),
                onTap: () async {
                  Usuario nuevoUsuario = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarUsuarioScreen(
                        tipo: 'enlace',
                        inicial: _usuario.enlace,
                      ),
                    ),
                  );
                  setState(() {
                    _usuario = nuevoUsuario;
                  });
                },
              ),
              /*ListTile(
              onTap: () {
                if (googleConectado) {
                  if (facebookConectado || appleConectado) {
                    _desconectarGoogle();
                  }
                } else {
                  _conectarConGoogle();
                }
              },
              subtitle: Text(googleConectado ? 'Conectado' : 'Desconectado'),
              title: Text(
                'Google',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w400, color: MainTheme.gris),
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                if (facebookConectado) {
                  if (googleConectado || appleConectado) {
                    _desconectarFacebook();
                  }
                } else {
                  _conectarConFacebook();
                }
              },
              subtitle: Text(facebookConectado ? 'Conectado' : 'Desconectado'),
              title: Text(
                'Facebook',
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w400, color: MainTheme.gris),
              ),
            ),
            Divider(
              height: Platform.isIOS ? 1 : 0,
            ),
            _mostrarBotonApple(),
            */
              Container(
                  color: Color(0xFFDFDFDF),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      "General",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: MainTheme.gris),
                    ),
                  )),
              ListTile(
                title: Text(
                  'Términos y condiciones',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InformacionScreen(tipo: 'Terminos y condiciones'),
                      ));
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Políticas de privacidad',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InformacionScreen(tipo: 'Políticas de privacidad'),
                      ));
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Acerca de Chefium',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InformacionScreen(tipo: 'Acerca de Chefium'),
                      ));
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Versión: 1.0.0',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400, color: MainTheme.gris),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
