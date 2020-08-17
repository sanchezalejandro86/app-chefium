import 'package:chefium/screens/busqueda_screen.dart';
import 'package:chefium/screens/crear_receta_screen.dart';
import 'package:chefium/screens/filtros_screen.dart';
import 'package:chefium/screens/home_screen.dart';
import 'package:chefium/screens/informacion_screen.dart';
import 'package:chefium/screens/login_screen.dart';
import 'package:chefium/screens/main_screen.dart';
import 'package:chefium/screens/perfil_screen.dart';
import 'package:chefium/screens/receta_screen.dart';
import 'package:chefium/screens/splash_screen.dart';
import 'package:chefium/screens/editar_usuario_screen.dart';
import 'package:chefium/screens/configuracion_screen.dart';
import 'package:chefium/themes/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFF503130)));
  runApp(Chefium());
}

class Chefium extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Chefium',
      theme: MainTheme.theme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => MainScreen(),
        '/busqueda': (context) => BusquedaScreen(),
        '/perfil': (context) => PerfilScreen(),
        '/configuracion': (context) => ConfiguracionScreen(),
        '/editarUsuario': (context) => EditarUsuarioScreen(),
        '/informacion': (context) => InformacionScreen(),
        '/filtros': (context) => FiltrosScreen(),
        '/crear': (context) => CrearRecetaScreen()
      },
    );
  }
}
