import 'package:flutter/material.dart';

const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F3F3);
const kLightAccentColor = Color(0xFF77ad39);
//const kLightHighlightColor = Color(0xFFada939);
const kLightHighlightColor = Color(0xFF3977ad);

const kDarkPrimaryColor = Color(0xFF000000);
const kDarkSecondaryColor = Color(0xFF252525);
const kDarkAccentColor = Color(0xFF8bc34a);
//const kDarkHighlightColor = Color(0xFFc3bf4a);
const kDarkHighlightColor = Color(0xFF4a8bc3);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kDarkAccentColor,
  highlightColor: kDarkHighlightColor,
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
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkPrimaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: kDarkPrimaryColor,
        displayColor: kDarkPrimaryColor,
      ),
);
