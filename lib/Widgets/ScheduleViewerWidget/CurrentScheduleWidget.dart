import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/LessonsLogic.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/ScheduleData.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/GetWeekScheduleAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/InternetConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
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
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TabController tabController =
      TabController(length: 10, vsync: AnimatedListState());
  DateTime currentDate = DateTime.now();
  bool isConnected = true;
  String errorMessage;
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

  @override
  void initState() {
    super.initState();
    tabController.addListener(tabListener);
    getLessons(false);
  }

  void tabListener() {
    int tabIndex = tabController.index;
    DateTime newDate;
    try {
      //get the date from the widgets class if it exists and change the date button
      DayScheduleWidget currentScheduleWidget = dayScheduleWidgets[tabIndex];
      if (currentScheduleWidget != null) {
        if (currentScheduleWidget.dateTime != null) {
          var formatter = new DateFormat('dd-MM-yyyy');
          newDate = formatter.parse(currentScheduleWidget.dateTime);
        }
      }
    } catch (Exception) {
      //widget isnt type of dayschedulewidget
    }
    if (newDate != null && mounted) {
      setState(() {
        currentDate = newDate;
      });
    }
  }

  void handleNewDate(date) {
    print(date);
  }

  Future<Null> refresher()async {
    await getLessons(true);
    await Future.delayed(Duration(milliseconds: 200));
  }

  Future<Null> getLessons(bool getOnline) async {
    String lesson = await UserPreferences().getCurrentLesson();
    var result = await ScheduleData().getSchedule(lesson,getOnline);
    Rooster rooster;
    if (result is Rooster) {
      rooster = result;
      if (mounted) {
        setState(() {
          errorMessage = null;
        });
      }
    }
    if (rooster != null) {
      currentSchedule = rooster;
    } else {
      var message = result[0] ?? "Er is een fout opgetreden";
      if (mounted) {
        setState(() {
          errorMessage = message;
        });
      }
    }
    setScheduleDisplayDate(DateTime.now());
    setScheduleItems();
  }

  Future timeOut() {
    return new Future.delayed(const Duration(seconds: 10), () => "10");
  }

  onTimeOut() {
    if (errorMessage != null) {
      Widget widget = Container(
        color: AppColors.foregroundColor,
        child: Center(
          child: Text(errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryTextColor)),
        ),
      );
      if (mounted) {
        setState(() {
          dayScheduleWidgets = [
            widget,
            widget,
            widget,
            widget,
            widget,
            widget,
            widget,
            widget,
            widget,
            widget
          ];
        });
      }
    }
  }

  setScheduleItems() {
    if (currentSchedule != null) {
      List<DayScheduleWidget> dayScheduleWidgetsTemp = List();
      for (var dag in currentSchedule.dagen) {
        dayScheduleWidgetsTemp
            .add(DayScheduleWidget(dag.date, dag: dag, onRefresh: refresher, refreshKey: refreshKey,));
      }
      if (mounted) {
        setState(() {
          dayScheduleWidgets = dayScheduleWidgetsTemp;
        });
      }
    } else {
      timeOut().whenComplete(() {
        onTimeOut();
      });
    }
  }

  setScheduleDisplayDate(DateTime date) {
    setTabViewerToDate(date);
  }

  setTabViewerToDate(DateTime datetime) {
    if (currentSchedule != null) {
      //loop through the schedule
      for (var i = 0; i < currentSchedule.dagen.length; i++) {
        try {
          var formatter = new DateFormat('dd-MM-yyyy');
          //get the date param and check if it exists in the current schedule
          DateTime date = formatter.parse(currentSchedule.dagen[i].date);
          if (date.year == datetime.year &&
              date.day == datetime.day &&
              date.month == datetime.month) {
            //the date param exists so the tabController animates to the tab with that date and sets the currentDate to the date
            tabController.animateTo(i);
            if (mounted) {
              setState(() {
                currentDate = date;
              });
            }
            break;
          } else {
            //get the last date from the current schedule
            var lastdate = formatter.parse(
                currentSchedule.dagen[currentSchedule.dagen.length - 1].date);
            //if the last date isnt at the same moment as the date param and its before the first date in the schedule then show a SnackBar
            if (!datetime.isAtSameMomentAs(
                    formatter.parse(currentSchedule.dagen[0].date)) &&
                !datetime
                    .isAfter(formatter.parse(currentSchedule.dagen[0].date))) {
              //The date param is before the first date in the current schedule
              final snackBar = SnackBar(
                content: Text(
                    'Geen rooster gevonden misschien ben je vrij of is het rooster niet beschikbaar, ga maar uit van het laatste',
                    style: TextStyle(color: AppColors.primaryTextColor)),
                action: SnackBarAction(
                  label: 'Verbergen',
                  onPressed: () {
                    // Some code to undo the change!
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              break;
            } else if (datetime.isAfter(lastdate)) {
              //if the date is after the lastDate show a SnackBar
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
            } else {
              DateTime datetimeTemp = datetime;
              DateTime newDate;
              if (datetime.weekday == DateTime.saturday) {
                newDate = datetimeTemp.add(Duration(days: 2));
                setTabViewerToDate(newDate);
              } else if (datetime.weekday == DateTime.sunday) {
                newDate = datetimeTemp.add(Duration(days: 1));
                setTabViewerToDate(newDate);
              }
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
  OnRefresh(){
    setScheduleItems();
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
                  color: AppColors.primaryTextColor,
                ),
                onPressed: () {
                  DateTime tempdate = currentDate;
                  //check if date is monday if it is go to friday
                  int dayInWeek = currentDate.weekday;
                  DateTime date;
                  if (dayInWeek == DateTime.monday) {
                    date = tempdate.subtract(Duration(days: 3));
                  } else {
                    date = tempdate.subtract(Duration(days: 1));
                  }
                  if (date != null) {
                    setScheduleDisplayDate(date);
                  }
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
                    Icon(Icons.today, color: AppColors.primaryTextColor),
                    Text("Datum: " + formatter.format(currentDate) ?? "",
                        style: TextStyle(color: AppColors.primaryTextColor)),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon:
                    Icon(Icons.arrow_right, color: AppColors.primaryTextColor),
                onPressed: () {
                  DateTime tempdate = currentDate;
                  DateTime date;
                  if (currentDate.weekday == DateTime.friday) {
                    date = tempdate.add(Duration(days: 3));
                  } else {
                    date = tempdate.add(Duration(days: 1));
                  }
                  if (date != null) {
                    setScheduleDisplayDate(date);
                  }
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
