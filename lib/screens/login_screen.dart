import 'dart:io' show Platform;
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:chefium/widgets/cargando_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FacebookLogin _facebookSignIn = new FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  UsuarioService _usuarioService = new UsuarioService();

  void _entrarConApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (result.status) {
      case AuthorizationStatus.authorized:
        String token = String.fromCharCodes(result.credential.identityToken);
        prefs.setString('idApple', result.credential.user);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CargandoDialog(),
        );
        print('---token---');
        print(token);
        try {
          //Navigator.pop(context);
          //Navigator.pushReplacementNamed(context, '/home');

        } catch (e) {
          Navigator.pop(context);
        }
        break;
      case AuthorizationStatus.error:
        print("Ocurrió un error inesperado");
        break;

      case AuthorizationStatus.cancelled:
        print("Cancelado por el usuario");
        break;
    }
  }

  Future<Null> _entrarConFacebook() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        prefs.setString('idFacebook', accessToken.userId);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CargandoDialog(),
        );
        try {
          Usuario usuario =
              await _usuarioService.loginFacebook(accessToken.token);
          print('---token---');
          print(usuario.token);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(usuario: usuario),
            ),
          );
        } catch (e) {
          print(e);
          Navigator.pop(context);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Facebook Cancelled Status');
        break;
      case FacebookLoginStatus.error:
        print('Facebook Error Status');
        break;
    }
  }

  void _entrarConGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      GoogleSignInAuthentication authentication = await account.authentication;
      String token = authentication.accessToken;
      print('---token---');
      print(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('idGoogle', account.id);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CargandoDialog(),
      );
      Usuario usuario = await _usuarioService.loginGoogle(token);
      Navigator.pop(context);
      print(usuario.token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(usuario: usuario),
        ),
      );
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  _mostrarBotonApple() {
    if (Platform.isIOS) {
      return Container(
        height: 40,
        child: AppleSignInButton(
          onPressed: () {
            _entrarConApple();
          },
          style: ButtonStyle.black,
          type: ButtonType.defaultButton,
          cornerRadius: 20,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/images/login.png'),
                    fit: BoxFit.scaleDown)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage('lib/assets/images/logotipo.png'),
                  width: 200),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Bienvenido a la cocina fácil y rica',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        _entrarConGoogle();
                      },
                      color: Color(0xFFEA4335),
                      child: Container(
                        height: 40,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                              size: 18,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                              "Google",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: FlatButton(
                        color: Color(0xFF3B5998),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          _entrarConFacebook();
                        },
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: 18,
                              ),
                              Container(
                                width: 5,
                              ),
                              Text(
                                'Facebook',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _mostrarBotonApple()
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
