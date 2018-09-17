import 'dart:async';
import 'dart:convert';

import 'package:hoornbeeck_rooster_info_app/DAL/GetWeekScheduleAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Dag.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Les.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Uur.dart';

class LessonsLogic {
  _getLessen(var value) {
    try {
      List<Les> lessen = List<Les>();
      for (var les in value) {
        var newLes = Les()
          ..type = les["type"] ?? ""
          ..vak = les["vak"] ?? ""
          ..docent = les["docent"] ?? ""
          ..lokaal = les["lokaal"] ?? ""
          ..extra = les["extra"] ?? ""
          ..groep=les["groep"]??"";
        lessen.add(newLes);
      }
      return lessen;
    }
    catch (Exception) {
      return null;
    }
  }

  _getUren(var value) {
    try {
      List<Uur> uren = List<Uur>();
      for (var uur in value) {
        var newUur = Uur()
          ..uur = uur["uur"] ?? ""
          ..lestijd = uur["lestijd"] ?? ""
          ..lessen = _getLessen(uur["lessen"]) ?? [Les()];
        uren.add(newUur);
      }
      return uren;
    }
    catch (Exception) {
return null;
    }
  }

  _getRooster(var value) {

    try {
      List<Dag> dagen= List();
      for (var item in value) {
        dagen.add(Dag()
          ..dag = item["dag"] ?? ""
          ..date = item["date"] ?? ""
          ..datum = item["datum"] ?? ""
          ..roostertekst=item["roostertekst"]??""
          ..uren = _getUren(item["uren"]) ?? [Uur()]);
      }
      Rooster rooster = Rooster()..dagen=dagen;
      return rooster;
    }
    catch (Exception) {
return null;
    }
  }

  Future<Rooster> getLessons() async {
    //create an empty Rooster object

    //get the current lesson
    String lesson = await UserPreferences().getCurrentLesson();
    //get the data from api with the CurrentLesson
    String result = await GetWeekScheduleAPIConnection().getByCode(lesson);
    //decode the result to a json Map
    Map map = json.decode(result);
    //loop through the map and add it to a object Rooster
    return _getRooster(map["rooster"]);
  }
}