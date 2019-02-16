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

  static getColors() async{
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
      actionColor = Color(0xFF1C9D9F);
      actionTextColor = Color(0xFF1C9D9F);
      primaryTextColor = Color(0xFF1C9D9F);
      secondaryTextColor = Color(0xFF1C9D9F);
      backgroundColor = Color(0xFF1C9D9F);
      backgroundTextColor = Color(0xFF1C9D9F);
      foregroundColor = Color(0xFF1C9D9F);
      warningColor = Color(0xFF1C9D9F);
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
