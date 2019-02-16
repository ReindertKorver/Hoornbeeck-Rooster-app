import 'dart:async';
import 'dart:convert';

import 'package:hoornbeeck_rooster_info_app/BLL/LessonsLogic.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/GetWeekScheduleAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/InternetConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:intl/intl.dart';

class ScheduleData {
  static String schedulecodeString = "schedulecode";
  static String lastupdateString = "lastupdate";
  static String scheduleString = "schedule";

  static DateTime lastUpdate;
  static DateFormat lastUpdateFormatter = DateFormat("dd/MM/yyyy HH:mm");

  Future<dynamic> getSchedule(String value, bool getOnline) async {
    var realConnection = await InternetConnection.checkConnection();
    if (getOnline && realConnection) {
      //if request is online and internet works
      return await _getOnlineSchedule(value);
    } else {
      var result = await _getLocalSchedule(value);
      if (result != null && result.runtimeType != List) {
        try {
          //not online but schedule is found in local data
          Rooster rooster =
              await LessonsLogic().getLessonsFromJsonString(result);
          if (rooster != null) {
            return rooster;
          } else {
            //result couldn't be parsed
            return null;
          }
        } catch (e) {
          var realConnection = await InternetConnection.checkConnection();
          if (realConnection) {
            return await _getOnlineSchedule(value);
          } else {
            //Local schedule went wrong and the online schedule cant be accessed
          }
        }
      } else {
        var realConnection = await InternetConnection.checkConnection();
        if (realConnection) {
          return await _getOnlineSchedule(value);
        } else {
          //Local schedule went wrong and the online schedule cant be accessed
        }
      }
    }
  }

  _getLocalSchedule(value) async {
    return await UserPreferences().getLocalSchedule(value);
  }

  _getOnlineSchedule(String value) async {
    var result = await GetWeekScheduleAPIConnection().getByCode(value);
    if (result != null && result.runtimeType == String) {
      var date = DateTime.now();

      Rooster rooster = await LessonsLogic().getLessonsFromJsonString(result);
      if (rooster != null) {
        UserPreferences().setLocalSchedule(result, value, date);
        ScheduleData.lastUpdate = DateTime.now();
        return rooster;
      } else {
        //online and can get a result from api but cant convert api result to object
        return null;
      }
    } else {
      //online but cant get a result from api
      return result;
    }
  }
}
