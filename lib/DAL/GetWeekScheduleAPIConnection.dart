import 'dart:async';
import 'dart:convert';
import 'package:hoornbeeck_rooster_info_app/Entities/APICredentials.dart';
import 'package:http/http.dart' as http;

class GetWeekScheduleAPIConnection{
  Future<dynamic> getByCode(String value) async {
    try {
      http.Response response =  await http.get(APICredentials.getByCodeUrl+ value);
      print(response.body);
      var result = json.decode(response.body);
      print(result);
      return result;
    } catch (Exception) {
      return "Er kon geen verbinding worden gemaakt, check je internet verbinding";
    }
  }
}
