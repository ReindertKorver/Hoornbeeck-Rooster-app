import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';

class AppColors {
  static Color actionColor = Color(0xFF127a7b);
  static Color actionTextColor = Colors.white;
  static Color primaryTextColor = Colors.black;
  static Color secondaryTextColor = Colors.grey[600];
  static Color backgroundColor = Color(0xFF127a7b);
  static Color backgroundTextColor = Colors.white;
  static Color foregroundColor = Colors.white;
  static Color warningColor = Colors.red;

  static setDefaultColors() async {
    actionColor = Color(0xFF127a7b);
    actionTextColor = Colors.white;
    primaryTextColor = Colors.black;
    secondaryTextColor = Colors.grey[600];
    backgroundColor = Color(0xFF127a7b);
    backgroundTextColor = Colors.white;
    foregroundColor = Colors.white;
    warningColor = Colors.red;
    var colors = [
      actionColor = Color(0xFF127a7b),
      actionTextColor = Colors.white,
      primaryTextColor = Colors.black,
      secondaryTextColor = Colors.grey[600],
      backgroundColor = Color(0xFF127a7b),
      backgroundTextColor = Colors.white,
      foregroundColor = Colors.white,
      warningColor = Colors.red,
    ];
    await setColors(colors);
    return colors;
  }

  static getColors() async {
    try {
      List<Color> colorsFromUP = await UserPreferences().getColors();
      actionColor = colorsFromUP[0];
      actionTextColor = colorsFromUP[1];
      primaryTextColor = colorsFromUP[2];
      secondaryTextColor = colorsFromUP[3];
      backgroundColor = colorsFromUP[4];
      backgroundTextColor = colorsFromUP[5];
      foregroundColor = colorsFromUP[6];
      warningColor = colorsFromUP[7];
    } catch (e) {
      setDefaultColors();
    }
  }

  static setColors(List<Color> colors) {
    try {
      UserPreferences().setColors(colors);
      getColors();
      return "Opgeslagen";
    } catch (e) {
      return "Er is iets fout gegaan bij het opslaan van de kleuren";
    }
  }
}
