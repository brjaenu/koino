import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    const primaryColor = CustomColor.blue;
    const primaryColorDark = CustomColor.darkBlue;
    const primaryColorLight = CustomColor.lightBlue;
    const accentColor = CustomColor.yellow;
    const errorColor = CustomColor.red;

    const whiteColor = CustomColor.white;
    const blackColor = CustomColor.black;

    return ThemeData(
      primarySwatch: CustomColor.primarySwatch,
      scaffoldBackgroundColor: CustomColor.white,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      accentColor: accentColor,
      errorColor: errorColor,
      fontFamily: 'Futura',

      // FABTheme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
      ),

      // Appbar Theme
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: whiteColor,
        iconTheme: const IconThemeData(color: CustomColor.black),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: primaryColorDark,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: primaryColor,
        selectedItemColor: whiteColor,
        backgroundColor: whiteColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      // TextTheme
      textTheme: TextTheme(
        headline2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
        ),
        headline1: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
          fontSize: 48.0,
        ),
        headline3: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
          fontSize: 20.0,
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
          fontSize: 16.0,
        ),
        bodyText1: TextStyle(
          color: primaryColorDark,
          fontSize: 14.0,
        ),
        // TextInputStyle
        subtitle1: TextStyle(
          color: whiteColor,
          fontSize: 14.0,
        ),
      ),
      accentTextTheme: TextTheme(
        headline3: TextStyle(
          fontWeight: FontWeight.bold,
          color: whiteColor,
          fontSize: 20.0,
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.bold,
          color: whiteColor,
          fontSize: 16.0,
        ),
        bodyText1: TextStyle(
          color: whiteColor,
          fontSize: 14.0,
        ),
        // TextInputColor
        subtitle1: TextStyle(
          color: primaryColorDark,
          fontSize: 14.0,
        ),
      ),

      // CardTheme
      cardTheme: CardTheme(
        margin: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),

      // FormInputTheme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryColorLight,
        focusColor: primaryColorLight,
        hoverColor: primaryColorLight,
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColorDark)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColorDark)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: errorColor)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: errorColor)),
        hintStyle: TextStyle(color: whiteColor, fontSize: 14.0),
      ),

      //ButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            alignment: AlignmentDirectional.center,
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(whiteColor),
            elevation: MaterialStateProperty.all(1.0),
            minimumSize: MaterialStateProperty.all(Size(10, 48.0)),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18.0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))))),
      ),

      iconTheme: IconThemeData(color: whiteColor, size: 20.0),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColorDark,
        selectionColor: primaryColorDark,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

class CustomColor {
// https://coolors.co/ef476f-ffd166-06d6a0-118ab2-073b4c
  static const Color red = Color(0xFFEF476F);
  static const Color lightBlue = Color(0xFF62B2CA);
  static const Color blue = Color(0xFF118AB2);
  static const Color darkBlue = Color(0xFF073B4C);
  static const Color yellow = Color(0xFFFFD166);
  static const Color green = Color(0xFF06D6A0);

  static const Color white = Color(0xFFFFFFFC);
  static const Color black = Color(0xFF000000);

  static const MaterialColor primarySwatch =
      const MaterialColor(0xFF118AB2, primaryPalette);

  static const Map<int, Color> primaryPalette = {
    50: Color(0x1A118AB2),
    100: Color(0x4D118AB2),
    200: Color(0x80118AB2),
    300: Color(0xB3118AB2),
    400: Color(0xE6118AB2),
    500: Color(0xFF118AB2),
    600: Color(0xFF118AB2),
    700: Color(0xFF118AB2),
    800: Color(0xFF118AB2),
    900: Color(0xFF118AB2),
  };
}

/*
ThemeData(
              primarySwatch: Colors.amber,
              scaffoldBackgroundColor: Colors.grey[50],
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                color: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                textTheme: const TextTheme(
                  headline6: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity)
 */