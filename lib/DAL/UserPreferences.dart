import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  SharedPreferences sharedPreferences;
  String FIRSTSTART = "FIRSTSTART";

  UserPreferences() {
    _initializeUserPreferences();
  }

  _initializeUserPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> isFirstStart() async {
    try {
      bool result = sharedPreferences.getBool(FIRSTSTART);
      if(result==null)
        {
          sharedPreferences.setBool(FIRSTSTART, true);
        }
    } catch (Exception) {

    }
    return /*result ??*/ true;
  }
}
