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

  Future<dynamic> getSchedule(String value) async {
    bool hasConnection = await InternetConnection.checkConnection();
    if (hasConnection) {
      var result = await _getOnlineSchedule(value);
      if (result != null&&result.runtimeType ==String ) {
        var date = DateTime.now();

        Rooster rooster = await LessonsLogic().getLessonsFromJsonString(result);
        if (rooster != null) {
          UserPreferences().setLocalSchedule(result, value, date);
          ScheduleData.lastUpdate=DateTime.now();
          return rooster;
        }
        else{
          //online and can get a result from api but cant convert api result to object
          return null;
        }
      }
      else{
        //online but cant get a result from api
        return result;
      }
    } else {
      var result = await _getLocalSchedule(value);
      if (result != null&&result.runtimeType !=List) {
        //not online but schedule is found in local data
        Rooster rooster = await LessonsLogic().getLessonsFromJsonString(result);
        if (rooster != null) {
          return rooster;
        }
        else{
          //offline and can get a result from local data but cant convert local data to object
          return null;
        }
      }else{
        //not online and the schedule isn't found in local data
        return result;
      }
    }
  }

  _getLocalSchedule(value) async {
    return await UserPreferences().getLocalSchedule(value);
  }

  _getOnlineSchedule(String value) async {
    return await GetWeekScheduleAPIConnection().getByCode(value);
  }
}
