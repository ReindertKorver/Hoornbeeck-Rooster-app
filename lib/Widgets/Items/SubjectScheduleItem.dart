import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';

class SubjectScheduleItem extends StatefulWidget {
  @override
  _SubjectScheduleItemState createState() => _SubjectScheduleItemState();
}

class _SubjectScheduleItemState extends State<SubjectScheduleItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Vak 1"),
              ),
              Expanded(child: Container(),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("15:00"),
                    ),
                    Padding(
                      padding: const  EdgeInsets.only(left: 8.0),
                      child: Text("16:00"),
                    ),
                  ],
                ),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Docent: pgj"),
                Text("Klas: T4i3AR"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Lokaal: a301"),
          ),
        ],
      ),
    );
  }
}
