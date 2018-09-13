import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/DateLogic.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/LessonsLogic.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/GetWeekScheduleAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/InternetConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Items/ScheduleItem.dart';
import 'package:intl/intl.dart';

class CurrentScheduleWidget extends StatefulWidget {
  @override
  _CurrentScheduleWidgetState createState() => _CurrentScheduleWidgetState();
}

class _CurrentScheduleWidgetState extends State<CurrentScheduleWidget> {
  TabController tabController = TabController(length: 3, vsync: null);
  DateTime currentDate = DateTime.now();
  int week = 0;
  var formatter = new DateFormat("dd-MM-yy");
  Rooster currentSchedule;

  void handleNewDate(date) {
    print(date);
  }

  getLessons() async {
    Rooster rooster = await LessonsLogic().getLessons();
    if (mounted) {
      setState(() {
        currentSchedule = rooster;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        week = DateLogic().getWeekOfYearFromDate(currentDate);
      });
    }
    getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_left,
                ),
                onPressed: () {
                  setState(() {
                    currentDate.add(Duration(days: -1));
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              MaterialButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Icon(Icons.today),
                    Text("Datum: " + formatter.format(currentDate) ?? ""),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_right,
                ),
                onPressed: () {
                  DateTime tempdate = currentDate;
                  var date = tempdate.add(Duration(days: 1));
                  setState(() {
                    currentDate = date;
                  });
                },
              ),
            ],
          ),
          Expanded(
              child: Container(
            color: Color(0xFFefefef),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    ScheduleItem(),
                    ScheduleItem(),
                    ScheduleItem()
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
