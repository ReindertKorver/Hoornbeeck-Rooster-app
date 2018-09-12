import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class CurrentScheduleWidget extends StatefulWidget {
  @override
  _CurrentScheduleWidgetState createState() => _CurrentScheduleWidgetState();
}

class _CurrentScheduleWidgetState extends State<CurrentScheduleWidget> {
  void handleNewDate(date) {
    print(date);
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
                onPressed: () {},
              ),
              Expanded(
                child: Container(),
              ),
              MaterialButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Icon(Icons.today),
                    Text("Vandaag"),
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
                onPressed: () {},
              ),
            ],
          ),
          Divider(),
          Expanded(
              child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                child: Container(height: 150.0, child: Text("gister")),
              ),
              Card(
                child: Container(height: 150.0, child: Text("vandaag")),
              ),
              Card(child: Container(height: 150.0, child: Text("morgen"))),
              Card(child: Container(height: 150.0, child: Text("over morgen")))
            ],
          )),
        ],
      ),
    );
  }
}
