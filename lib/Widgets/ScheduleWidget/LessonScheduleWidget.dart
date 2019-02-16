import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Les.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';

class LessonScheduleWidget extends StatefulWidget {
  LessonScheduleWidget({@required this.les});

  final Les les;

  @override
  _LessonScheduleWidgetState createState() =>
      _LessonScheduleWidgetState(les: les);
}

class _LessonScheduleWidgetState extends State<LessonScheduleWidget> {
  _LessonScheduleWidgetState({@required this.les});

  Les les;
  TextStyle style =
      TextStyle(color: AppColors.actionColor, fontWeight: FontWeight.bold);
  TextStyle changedStyle =
      TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);
  TextStyle cancelledStyle = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.lineThrough);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (les.type == "vervallen") {
      setState(() {
        style = cancelledStyle;
      });
    } else if (les.type == "gewijzigd") {
      setState(() {
        style = changedStyle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (les.vak != null && les.vak != "")
                  ? Row(
                      children: <Widget>[
                        Text("Vak: ",style: TextStyle(color: AppColors.primaryTextColor)),
                        Text(
                          les.vak,
                          style: style,
                        ),
                      ],
                    )
                  : Text("Vak: geen",style: TextStyle(color: AppColors.primaryTextColor)),
              (les.docent != null && les.docent != "")
                  ? Row(
                      children: <Widget>[
                        Text("Docent: ",style: TextStyle(color: AppColors.primaryTextColor)),
                        Text(
                          les.docent,
                          style: style,
                        ),
                      ],
                    )
                  : Text("Docent: geen",style: TextStyle(color: AppColors.primaryTextColor)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (les.lokaal != null && les.lokaal != "")
                  ? Row(
                      children: <Widget>[
                        Text("Lokaal: ",style: TextStyle(color: AppColors.primaryTextColor)),
                        Text(
                          les.lokaal,
                          style: style,
                        ),
                      ],
                    )
                  : Text("Lokaal: geen",style: TextStyle(color: AppColors.primaryTextColor)),
              (les.groep != null && les.groep != "")
                  ? Row(
                      children: <Widget>[
                        Text("Groep: ",style: TextStyle(color: AppColors.primaryTextColor)),
                        Text(
                          les.groep +
                              ((les.extra != null) ? " " + les.extra : ""),
                          style: style,
                        ),
                      ],
                    )
                  : Text(
                      ((les.extra != null) ? " " + les.extra : "Groep: geen"),
                      style: style,
                    ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
