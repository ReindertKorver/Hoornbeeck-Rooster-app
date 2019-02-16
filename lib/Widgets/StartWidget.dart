import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:flutter/services.dart';

class StartWidget extends StatefulWidget {
  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor:AppColors.backgroundColor,
        title: Text(
          "Hoornbeeck rooster",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.backgroundTextColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
            child: Column(
              children: <Widget>[
                Center(child: Image.asset("assets/Resources/Images/logo.png"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
