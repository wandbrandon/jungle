import 'package:flutter/material.dart';

const kDarkPrimaryColor = Color(0xFF000000);
const kDarkSecondaryColor = Color(0xFF252525);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFDFDFDF);
const kLightAccentColor = Color(0xFF64d8cb);
const kDarkAccentColor = Color(0xFF64d8cb);

final kDarkTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kDarkAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightPrimaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: kLightPrimaryColor,
        displayColor: kLightPrimaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kLightAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkPrimaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: kDarkPrimaryColor,
        displayColor: kDarkPrimaryColor,
      ),
);
