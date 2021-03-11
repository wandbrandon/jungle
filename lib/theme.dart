import 'package:flutter/material.dart';

const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFe5e5ea);
const kLightAccentColor = Color(0xFF77ad39);
const kLightHighlightColor = Color(0xFFada939);
//const kLightHighlightColor = Color(0xFF3977ad);
const kLightErrorColor = Color(0xFFad3977);

const kDarkPrimaryColor = Color(0xFF000000);
const kDarkSecondaryColor = Color(0xFF151515);
const kDarkAccentColor = Color(0xFF8bc34a);
const kDarkHighlightColor = Color(0xFFc3bf4a);
const kDarkErrorColor = Color(0xFFc34a8b);
//const kDarkHighlightColor = Color(0xFF4a8bc3);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kDarkAccentColor,
  highlightColor: kDarkHighlightColor,
  errorColor: kDarkErrorColor,
  cardColor: kDarkSecondaryColor,
  splashColor: kDarkHighlightColor,
  colorScheme: ColorScheme.dark(primary: kDarkAccentColor),
  buttonTheme: ButtonThemeData(
      buttonColor: kDarkAccentColor, textTheme: ButtonTextTheme.accent),
  appBarTheme: AppBarTheme(brightness: Brightness.dark),
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightPrimaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: kLightPrimaryColor,
        displayColor: kLightPrimaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kLightAccentColor,
  highlightColor: kLightHighlightColor,
  errorColor: kLightErrorColor,
  cardColor: kLightSecondaryColor,
  splashColor: kLightHighlightColor,
  colorScheme: ColorScheme.light(
      primary: kLightAccentColor, background: kLightSecondaryColor),
  buttonTheme: ButtonThemeData(
      buttonColor: kLightAccentColor, textTheme: ButtonTextTheme.accent),
  appBarTheme: AppBarTheme(brightness: Brightness.light),
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkPrimaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: kDarkPrimaryColor,
        displayColor: kDarkPrimaryColor,
      ),
);
