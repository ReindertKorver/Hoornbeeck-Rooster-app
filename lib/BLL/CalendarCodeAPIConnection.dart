import 'dart:async';
import 'dart:convert';

import 'package:hoornbeeck_rooster_info_app/Entities/APICredentials.dart';
import 'package:http/http.dart' as http;

class CalendarCodeAPIConnection {
  CalendarCodeAPIConnection() {
    init();
  }

  void init() async {}

  Future<dynamic> searchCode(String value) async {
    try {
      http.Response response =  await http.get(APICredentials.searchCodeUrl + value);
      print(response.body);
     var result = json.decode(response.body);
     print(result);
     return result;
    } catch (Exception) {
return null;
    }
  }
}
