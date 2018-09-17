import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  SharedPreferences sharedPreferences;
  String FIRSTSTART = "FIRSTSTART";
  String CLASSLIST = "CLASSLIST";
  String CURRENTCLASS = "CURRENTCLASS";

  _initializeUserPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> isFirstStart() async {
    await _initializeUserPreferences();
    bool result = true;
    try {
      result = sharedPreferences.getBool(FIRSTSTART);
      sharedPreferences.setBool(FIRSTSTART, false);
    } catch (Exception) {}
    List<String> checkClass = await getClasses();
    if (checkClass[0] == "Fout") {
      return true;
    } else {
      if (result != null) {
        return result;
      } else {
        return true;
      }
    }
  }

  addClass(String classCode) async {
    await _initializeUserPreferences();
    try {
      List<String> list = sharedPreferences.getStringList(CLASSLIST);
      if (list != null) {
        list.add(classCode);
        sharedPreferences.setStringList(CLASSLIST, list);
      } else {
        sharedPreferences.setStringList(CLASSLIST, [classCode]);
      }
    } catch (Exception) {
      return "Er ging iets fout bij het opslaan van de geselecteerde waarde";
    }
  }

  removeClass(int index) async {
    await _initializeUserPreferences();
    try {
      List<String> list = sharedPreferences.getStringList(CLASSLIST);
      if (list != null) {
        list.removeAt(index);
        sharedPreferences.setStringList(CLASSLIST, list);
      }
    } catch (Exception) {
      return "Er ging iets fout bij verwijderen van een waarde";
    }
  }

  getClasses() async {
    await _initializeUserPreferences();
    try {
      List<String> list = sharedPreferences.getStringList(CLASSLIST);
      if (list != null && list.length > 0) {
        return list;
      } else {
        return [
          "Fout",
          "Geen roosters gevonden maak een nieuwe aan om er één te selecteren"
        ];
      }
    } catch (Exception) {
      return ["Fout", "Er ging iets fout bij het ophalen van de roosters"];
    }
  }

  setCurrentLesson(String code) async {
    await _initializeUserPreferences();
    try {
      List<String> list = sharedPreferences.getStringList(CLASSLIST);
      if (list != null) {
        sharedPreferences.setString(CURRENTCLASS, code);
        return "$code is ingesteld als standaard rooster";
      } else {
        return "Voeg eerst een roostercode toe voordat je een standaard rooster instelt";
      }
    } catch (Exception) {
      return "Er ging iets fout bij het opslaan van de geselecteerde waarde";
    }
  }

  getCurrentLesson() async {
    await _initializeUserPreferences();
    try {
      String code = sharedPreferences.getString(CURRENTCLASS);
      if (code != null && code.isNotEmpty) {
        return code;
      } else {
        List<String> list = sharedPreferences.getStringList(CLASSLIST);
        return list[0];
      }
    } catch (Exception) {
      return "Er ging iets fout bij het ophalen van de standaard roostercode";
    }
  }
}
