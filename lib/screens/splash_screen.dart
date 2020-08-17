import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/services/usuario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _terminoTiempo = false;
  UsuarioService _usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      new Future.delayed(const Duration(seconds: 3), () {
        _terminoTiempo = true;
        cambiarPantalla(context);
      });
    });
  }

  void cambiarPantalla(context) async {
    bool existe = await _usuarioService.existeUsuario();

    if (_terminoTiempo) {
      if (existe) {
        Usuario usuario = await _usuarioService.obtenerUsuarioLocal();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(usuario: usuario),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/assets/images/splash.jpg'),
                  fit: BoxFit.cover)),
        ),
        Center(
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('lib/assets/images/logotipo_amarillo.png'),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
