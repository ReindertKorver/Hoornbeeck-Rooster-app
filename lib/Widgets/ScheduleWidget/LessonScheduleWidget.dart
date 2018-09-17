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
  TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold);
  TextStyle changedStyle =
  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);
  TextStyle cancelledStyle =
  TextStyle(color: Colors.red, fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough);
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(les.type=="vervallen")
      {
        setState(() {
          style=cancelledStyle;
        });
      }
      else if(les.type=="gewijzigd"){
      setState(() {
        style=changedStyle;
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
              (les.vak != null&&les.vak!="") ? Row(
                children: <Widget>[
                  Text("Vak: "),
                  Text(les.vak,style: style,),
                ],
              ): Text("Vak: geen"),
              (les.docent != null &&les.docent!="") ? Row(
                children: <Widget>[
                  Text("Docent: "),
                  Text(les.docent,style: style,),
                ],
              ):  Text("Docent: geen"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (les.lokaal != null&&les.lokaal!="")
                  ? Row(
                      children: <Widget>[
                        Text("Lokaal: "),
                        Text(
                          les.lokaal,
                          style: style,
                        ),
                      ],
                    )
                  :  Text("Lokaal: geen"),
              (les.groep != null&&les.groep!="")
                  ? Row(
                      children: <Widget>[
                        Text("Groep: "),
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
