import 'package:flutter/material.dart';

class MainTheme {
  static Color get primaryColor => Color(0xFF503130);
  static Color get accentColor => Color(0xFFe6bc53);

  static Color get amarilloChefium => Color(0xFFe6bc53);
  static Color get verdeSuave => Color(0xFFb0c182);
  static Color get verdeOscuro => Color(0xFF525b37);
  static Color get marronChefium => Color(0xFF503130);
  static Color get gris => Color(0xFF53565A);
  static Color get grisClaro => Color(0xFF7F7F7F);

  static double elevation = 0;

  static String get fontFamily => 'SourceSerifPro';

  static ThemeData get theme => ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'SourceSansPro',
          ),
        ),
        backgroundColor: Colors.white,
        fontFamily: fontFamily,
        primaryColor: primaryColor,
        accentColor: accentColor,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 28,
          ),
          headline2: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 26,
          ),
          headline3: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 24,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 22,
          ),
          headline5: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 20,
          ),
          headline6: TextStyle(
            fontWeight: FontWeight.w700,
            color: marronChefium,
            fontSize: 18,
          ),
          button: TextStyle(
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
            color: marronChefium,
            fontSize: 16,
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            color: marronChefium,
            fontWeight: FontWeight.w700,
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            color: marronChefium,
            fontWeight: FontWeight.w700,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontFamily: 'SourceSansPro',
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontFamily: 'SourceSansPro',
          ),
          caption: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: elevation,
          color: Colors.transparent,
          iconTheme: IconThemeData(color: marronChefium),
        ),
      );
}
