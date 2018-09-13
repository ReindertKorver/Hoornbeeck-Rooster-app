import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/InternetConnection.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Schedules/CurrentScheduleWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Schedules/SchedulesWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Setup/SetupWidget.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  Widget body = Container();
  String title = "Rooster";
  IconData icon = Icons.event;
  int currentIndex = 0;
  List<Widget> screens = [CurrentScheduleWidget(), SchedulesWidget()];
  List<String> screenTitles = ["Rooster", "Roosters"];
  List<IconData> screenIcons = [Icons.event, Icons.event_note];
  StreamSubscription<ConnectivityResult> subscription;
  bool isConnected=true;
Widget connectionIcon=Icon(Icons.signal_wifi_4_bar,color: Colors.white,);
  setConnectionCheckerIcon() async {
    bool result = await InternetConnection.checkConnection();
    if(result!=isConnected){
    if (result) {
      setState(() {
        isConnected = result;
        connectionIcon=Icon(Icons.signal_wifi_4_bar,color: Colors.white,);
      });
    }
    else{
      setState(() {
        isConnected = result;
        connectionIcon=Icon(Icons.signal_wifi_off,color: Colors.red,);
      });
    }}
  }

  @override
  void initState() {
    super.initState();
    subscription = new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setConnectionCheckerIcon();
    });
    setState(() {
      body = screens[0];
      title = screenTitles[0];
      icon = screenIcons[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    setScreen(int index) {
      setState(() {
        body = screens[index];
        title = screenTitles[index];
        icon = screenIcons[index];
        currentIndex = index;
      });
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.primaryColorDark,
        accentColor: AppColors.accentColor,
      ),
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: (currentIndex == 1)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                    size: 30.0,
                  ),
                  backgroundColor: AppColors.accentColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetupWidget()),
                    );
                  },
                ),
              )
            : null,
        body: Container(
            color: AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Container(
                child: body,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    color: Colors.white),
              ),
            )),
        bottomNavigationBar: BottomAppBar(
            hasNotch: true,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                    child: FlatButton(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.event,
                              color: (currentIndex == 0)
                                  ? AppColors.primaryColor
                                  : Colors.grey[400],
                              size: (currentIndex == 0) ? 35.0 : 25.0),
                          Text(
                            "Rooster",
                            style: TextStyle(
                                color: (currentIndex == 0)
                                    ? AppColors.primaryColor
                                    : Colors.grey[400]),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setScreen(0);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                    child: FlatButton(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.event_note,
                            color: (currentIndex == 1)
                                ? AppColors.primaryColor
                                : Colors.grey[400],
                            size: (currentIndex == 1) ? 35.0 : 25.0,
                          ),
                          Text("Roosters",
                              style: TextStyle(
                                  color: (currentIndex == 1)
                                      ? AppColors.primaryColor
                                      : Colors.grey[400])),
                        ],
                      ),
                      onPressed: () {
                        setScreen(1);
                      },
                    ),
                  ),
                ])),
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: connectionIcon,
          )],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text('Rooster'),
                onTap: () {
                  setScreen(0);
                },
                selected: (currentIndex == 0) ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.event_note),
                title: Text('Roosters'),
                onTap: () {
                  setScreen(1);
                },
                selected: (currentIndex == 1) ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Info'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
