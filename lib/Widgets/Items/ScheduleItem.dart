import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Items/SubjectScheduleItem.dart';

class ScheduleItem extends StatefulWidget {
  @override
  _ScheduleItemState createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0,right: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Maandag",
                textAlign: TextAlign.left,
              ),
            ),
            SubjectScheduleItem(),
            SubjectScheduleItem(),
          ],
        ),
      ),
    );
  }
}
