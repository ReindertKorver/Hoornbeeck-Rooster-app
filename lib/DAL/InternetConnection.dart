import 'dart:async';

import 'package:connectivity/connectivity.dart';

class InternetConnection{
  static Future<bool> checkConnection()async{
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return false;
  }
}