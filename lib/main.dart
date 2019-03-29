import 'package:flutter/material.dart';
//import 'package:hoornbeeck_rooster_info_app/DAL/Database.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Main/MainWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Setup/SetupWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/StartWidget.dart';

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
        primaryColor: AppColors.backgroundColor,
        primaryColorDark: AppColors.backgroundColor,
        accentColor: AppColors.actionColor,
        textSelectionColor: AppColors.actionColor,
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
  Widget startWidget = StartWidget();
  Widget tempWidget = SetupWidget(
    isFirstPage: true,
  );
  bool isFirstStart;

  getStartWidget() async {
    isFirstStart = await UserPreferences().isFirstStart();
    tempWidget = (isFirstStart)
        ? SetupWidget(
            isFirstPage: true,
          )
        : MainWidget(updateUI: updateUI,);
    waitCompleted();
    if (isFirstStart) {
      //Database();
    }
  }

  waitCompleted() async {
    setState(() {
      startWidget = tempWidget;
    });
  }
void updateUI(){
    setState(() {

    });
}
  bool firstLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadColors(firstLoad);
  }

  void loadColors(bool firstload) async {
    if(firstload){
    await AppColors.setColors([
      AppColors.actionColor,
      AppColors.actionTextColor,
      AppColors.primaryTextColor,
      AppColors.secondaryTextColor,
      AppColors.backgroundColor,
      AppColors.backgroundTextColor,
      AppColors.foregroundColor,
      AppColors.warningColor,
    ]);
    print("Load setup");
    getStartWidget();
    firstLoad = false;
    }
    else{

      AppColors.getColors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.backgroundColor,
        primaryColorDark: AppColors.backgroundColor,
        accentColor: AppColors.actionColor,
        textSelectionColor: AppColors.actionColor,
      ),
      home: startWidget,
    );
  }
}
