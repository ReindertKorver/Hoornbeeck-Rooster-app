import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Main/MainWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Setup/SetupWidget.dart';

void main() => runApp(new StartPage());

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.primaryColorDark,
        accentColor: AppColors.accentColor,
        textTheme:  Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget startWidget = Container(child: Center(child: CircularProgressIndicator()),);
  getStartWidget()async {
    Widget widget =  await (UserPreferences().isFirstStart())?SetupWidget():MainWidget();
    setState(() {
      startWidget = widget;
    });
  }
bool firstLoad=true;
  @override
  Widget build(BuildContext context) {
    if(firstLoad){

      print("Load setup");
     getStartWidget();
     firstLoad=false;
    }
    return Scaffold(
      backgroundColor: AppColors.primaryColorDark,
      body: startWidget
    );
  }
}
