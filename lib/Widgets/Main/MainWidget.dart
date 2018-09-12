import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Schedules/CurrentScheduleWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Schedules/SchedulesWidget.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  Widget body=Container();
  String title = "Rooster";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.primaryColorDark,
        accentColor: AppColors.accentColor,
      ),
      home: Scaffold(
        body: body,
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
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
                  setState(() {
                    body=CurrentScheduleWidget();
                    title="Rooster";
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.event_note),
                title: Text('Roosters'),
                onTap: () {
                  setState(() {
                    body=SchedulesWidget();
                    title="Roosters";
                  });
                },
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
