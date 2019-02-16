import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Rooster.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleWidget/DayScheduleWidget.dart';

class Schedule extends StatefulWidget {
  Schedule({@required this.schedule});
  Rooster schedule;
  @override
  _ScheduleState createState() => _ScheduleState(schedule: schedule);
}

class _ScheduleState extends State<Schedule> {

  _ScheduleState({@required this.schedule});
  Rooster schedule;
  List<DayScheduleWidget>dayScheduleWidgets;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      List<DayScheduleWidget>dayScheduleWidgetsTemp=List();
      for(var dag in schedule.dagen){
        //dayScheduleWidgetsTemp.add(DayScheduleWidget(dag.date,dag: dag));
     }
     setState(() {
       dayScheduleWidgets=dayScheduleWidgetsTemp;
     });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0,right: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
            dayScheduleWidgets
        ),
      ),
    );
  }
}
