import 'package:animations/animations.dart';
import 'package:chefium/assets/icons/chefium_icons.dart';
import 'package:chefium/models/filtro.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/models/usuario.dart';
import 'package:chefium/screens/crear_receta_screen.dart';
import 'package:chefium/screens/filtros_screen.dart';
import 'package:chefium/screens/home_screen.dart';
import 'package:chefium/screens/perfil_screen.dart';
import 'package:chefium/services/receta_service.dart';
import 'package:chefium/themes/theme.dart';
import 'package:chefium/widgets/horizontal_receta.dart';
import 'package:chefium/widgets/square_receta.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final Usuario usuario;
  final Filtro filtro;
  final int tabInicial;
  MainScreen(
      {Key key,
      Filtro this.filtro,
      int this.tabInicial,
      @required this.usuario})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  List<Widget> _vistas;

  @override
  void initState() {
    _vistas = [
      HomeScreen(),
      CrearRecetaScreen(),
      FiltrosScreen(inicial: widget.filtro),
      PerfilScreen(usuario: widget.usuario)
    ];
    _index = widget.tabInicial ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _vistas[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(ChefiumIcons.spatula), title: Text('Inicio')),
          BottomNavigationBarItem(
              icon: Icon(ChefiumIcons.dish), title: Text('Nueva')),
          BottomNavigationBarItem(
              icon: Icon(ChefiumIcons.search), title: Text('Buscar')),
          BottomNavigationBarItem(
              icon: Icon(ChefiumIcons.user), title: Text('Perfil')),
        ],
        unselectedItemColor: Color(0xFF503130),
        selectedItemColor: Color(0xFF525b37),
        elevation: 0,
        currentIndex: _index,
        onTap: (int newValue) {
          setState(() {
            _index = newValue;
          });
        },
      ),
    );
  }
}
