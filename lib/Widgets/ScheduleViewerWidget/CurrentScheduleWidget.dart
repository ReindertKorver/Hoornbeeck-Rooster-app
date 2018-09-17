import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/LessonsLogic.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleWidget/DayScheduleWidget.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CurrentScheduleWidget extends StatefulWidget {
  @override
  _CurrentScheduleWidgetState createState() => _CurrentScheduleWidgetState();
}

class _CurrentScheduleWidgetState extends State<CurrentScheduleWidget> {
  TabController tabController =
      TabController(length: 10, vsync: AnimatedListState());
  DateTime currentDate = DateTime.now();
  int week = 0;
  var formatter = new DateFormat("dd-MM-yy");
  Rooster currentSchedule;
  Widget scheduleWidget = CircularProgressIndicator();
  List<Widget> dayScheduleWidgets = [
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator())
  ];

  void handleNewDate(date) {
    print(date);
  }

  getLessons() async {
    Rooster rooster = await LessonsLogic().getLessons();
    if (mounted) {
      setState(() {
        currentSchedule = rooster;
      });
      setScheduleDisplayDate(DateTime.now());
      setScheduleItems();
    }
  }

  setScheduleItems() {
    if (currentSchedule != null) {
      if (mounted) {
        List<DayScheduleWidget> dayScheduleWidgetsTemp = List();
        for (var dag in currentSchedule.dagen) {
          dayScheduleWidgetsTemp.add(DayScheduleWidget(dag: dag));
        }
        setState(() {
          dayScheduleWidgets = dayScheduleWidgetsTemp;
        });
      }
    }
  }

  setScheduleDisplayDate(DateTime date) {
    setTabViewerToDate(date);
  }

  setTabViewerToDate(DateTime datetime) {
    if (currentSchedule != null) {
      for (var i = 0; i < currentSchedule.dagen.length; i++) {
        try {
          var formatter = new DateFormat('dd-MM-yyyy');
          DateTime date = formatter.parse(currentSchedule.dagen[i].date);
          if (date.year == datetime.year &&
              date.day == datetime.day &&
              date.month == datetime.month) {
            tabController.animateTo(i);
            setState(() {
              currentDate = date;
            });
            break;
          } else {
            var lastdate=  formatter.parse(currentSchedule.dagen[currentSchedule.dagen.length-1].date);
            if (!datetime.isAtSameMomentAs(
                    formatter.parse(currentSchedule.dagen[0].date)) &&
                !datetime
                    .isAfter(formatter.parse(currentSchedule.dagen[0].date))) {
              final snackBar = SnackBar(
                content: Text(
                    'Geen rooster gevonden misschien ben je vrij of is het rooster niet beschikbaar, ga maar uit van het laatste'),
                action: SnackBarAction(
                  label: 'Verbergen',
                  onPressed: () {
                    // Some code to undo the change!
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              break;
            }else if(datetime.isAfter(lastdate)){
              final snackBar = SnackBar(
                content: Text(
                    'Geen rooster gevonden misschien ben je vrij of is het rooster niet beschikbaar, ga maar uit van het laatste'),
                action: SnackBarAction(
                  label: 'Verbergen',
                  onPressed: () {
                    // Some code to undo the change!
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              break;
            }
          }
        } catch (Exception) {}
      }
    }
  }

  editDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate.subtract(Duration(days: 730)),
        lastDate: currentDate.add(Duration(days: 730)));
    if (picked != null && picked != currentDate) {
      setState(() {
        setScheduleDisplayDate(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getLessons();
      setScheduleItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                splashColor: AppColors.accentColor,
                icon: Icon(
                  Icons.arrow_left,
                ),
                onPressed: () {
                  DateTime tempdate = currentDate;
                  var date = tempdate.subtract(Duration(days: 1));
                  setScheduleDisplayDate(date);
                },
              ),
              Expanded(
                child: Container(),
              ),
              MaterialButton(
                onPressed: () {
                  editDate();
                },
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
                splashColor: AppColors.accentColor,
                icon: Icon(
                  Icons.arrow_right,
                ),
                onPressed: () {
                  DateTime tempdate = currentDate;
                  var date = tempdate.add(Duration(days: 1));
                  setScheduleDisplayDate(date);
                },
              ),
            ],
          ),
          Expanded(
              child: Container(
            color: Color(0xFFefefef),
            child: DefaultTabController(
              length: 10,
              child: TabBarView(
                controller: tabController,
                children: dayScheduleWidgets,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
