import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Uur.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleWidget/LessonScheduleWidget.dart';
import 'package:intl/intl.dart';

class HourScheduleWidget extends StatefulWidget {
  HourScheduleWidget({@required this.uur});
  final Uur uur;
  @override
  _HourScheduleWidgetState createState() => _HourScheduleWidgetState(uur: uur);
}

class _HourScheduleWidgetState extends State<HourScheduleWidget> {
  _HourScheduleWidgetState({@required this.uur});
   Uur uur;
  List<LessonScheduleWidget>lessonScheduleWidgets;
  DateTime startTime;
  DateTime endTime; var formatter = new DateFormat('HH:mm');
  @override
  void initState() {
    super.initState();
    if (mounted) {
      List<LessonScheduleWidget>lessonScheduleWidgetsTemp=List();
      for(var les in uur.lessen){
        lessonScheduleWidgetsTemp.add(LessonScheduleWidget(les: les));
      }
      setState(() {
        lessonScheduleWidgets=lessonScheduleWidgetsTemp;
      });

      DateTime startTimeTemp = formatter.parse(uur.lestijd);
      DateTime endTimeTemp = startTimeTemp.add(Duration(minutes: 50));
      setState(() {
        startTime=startTimeTemp;
        endTime=endTimeTemp;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.foregroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Uur "+uur.uur.toString(),style: TextStyle(color: AppColors.primaryTextColor)),
              ),
              Expanded(child: Container(),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(formatter.format(startTime),style: TextStyle(color: AppColors.primaryTextColor)),
                    ),
                    Padding(
                      padding: const  EdgeInsets.only(left: 8.0),
                      child: Text(formatter.format(endTime),style: TextStyle(color: AppColors.primaryTextColor)),
                    ),
                  ],
                ),
              ),

            ],
          ),Divider(height: 2.0,),
         Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           mainAxisSize: MainAxisSize.max,
           children: lessonScheduleWidgets,),
        ],
      ),
    );
  }
}
