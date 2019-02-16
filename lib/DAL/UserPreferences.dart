import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/ScheduleData.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  SharedPreferences sharedPreferences;
  String FIRSTSTART = "FIRSTSTART";
  String CLASSLIST = "CLASSLIST";
  String CURRENTCLASS = "CURRENTCLASS";
  String LOCALSCHEDULES = "LOCALSCHEDULES";
  String COLORS = "COLORS";

  _initializeUserPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  setColors(List<Color> colors) async {
    List<String> colorStrings = [];
    colors.forEach((c) => colorStrings.add(c.value.toString()));
    await _initializeUserPreferences();
    sharedPreferences.setStringList(COLORS, colorStrings);
  }

  getColors() async {
    await _initializeUserPreferences();
    List<String> list = sharedPreferences.getStringList(COLORS);
    if (list != null) {
      List<Color> colors = [];
      list.forEach((c) => colors.add(Color(int.parse(c))));
      return colors;
    } else {
      return null;
    }
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
        for (var item in list) {
          if (item == classCode) {
            return "Deze code is al eens geselecteerd";
          }
        }
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

  getLocalSchedule(String value) async {
    await _initializeUserPreferences();
    try {
      List<String> schedules = sharedPreferences.getStringList(LOCALSCHEDULES);
      if (schedules != null && schedules.isNotEmpty && schedules.length > 0) {
        for (var item in schedules) {
          try {
            dynamic jsonMap = json.decode(item);
            if (jsonMap[ScheduleData.schedulecodeString] == value) {
              ScheduleData.lastUpdate = ScheduleData.lastUpdateFormatter
                  .parse(jsonMap[ScheduleData.lastupdateString]);
              return jsonMap[ScheduleData.scheduleString];
            }
          } catch (Exception) {
            print(Exception);
          }
        }

        return [
          "Er ging iets fout bij het ophalen van lokale rooster probeer opnieuw waarneer je internetverbinding hebt"
        ];
      } else {
        return [
          "Er ging iets fout bij het ophalen van lokale rooster probeer opnieuw waarneer je internetverbinding hebt"
        ];
      }
    } catch (Exception) {
      return [
        "Er ging iets fout bij het ophalen van lokale rooster probeer opnieuw waarneer je internetverbinding hebt"
      ];
    }
  }

  setLocalSchedule(String jsonMap, String scheduleCode, DateTime date) async {
    await _initializeUserPreferences();
    try {
      List<String> schedules =
          sharedPreferences.getStringList(LOCALSCHEDULES) ?? List();
      Map map = {
        ScheduleData.scheduleString: jsonMap,
        ScheduleData.schedulecodeString: scheduleCode,
        ScheduleData.lastupdateString:
            ScheduleData.lastUpdateFormatter.format(date),
      };
      //search for schedule in local data if exists update it
      OldScheduleResult resultMap = _checkOldSchedule(scheduleCode, date);
      if (resultMap == null) {
        schedules.add(json.encode(map));
      } else {
        schedules[resultMap.index] = json.encode(map);
      }

      sharedPreferences.setStringList(LOCALSCHEDULES, schedules);
    } catch (Exception) {
      return null;
    }
  }

  dynamic _checkOldSchedule(String scheduleCode, DateTime scheduleDate) {
    List<String> localSchedules =
        sharedPreferences.getStringList(LOCALSCHEDULES);
    Map finalMap;
    int mapIndex;
    if (localSchedules != null &&
        localSchedules.isNotEmpty &&
        localSchedules.length > 0) {
      for (var i = 0; i < localSchedules.length; i++) {
        try {
          dynamic jsonMap = json.decode(localSchedules[i]);
          if (jsonMap[ScheduleData.schedulecodeString] == scheduleCode) {
            finalMap = jsonMap;
            mapIndex = i;
            break;
          }
        } catch (Exception) {
          print(Exception);
        }
      }
      if (finalMap != null && mapIndex != null) {
        OldScheduleResult oldScheduleResult = OldScheduleResult();
        oldScheduleResult.map = finalMap;
        oldScheduleResult.index = mapIndex;
        return oldScheduleResult;
      } else {
        return null;
      }
    }
  }
}

class OldScheduleResult {
  Map map;
  int index;
}
