import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Dag.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleWidget/HourScheduleWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class DayScheduleWidget extends StatefulWidget {
  DayScheduleWidget({@required this.dag});

  final Dag dag;

  @override
  _DayScheduleWidgetState createState() => _DayScheduleWidgetState(dag: dag);
}

class _DayScheduleWidgetState extends State<DayScheduleWidget> {
  _DayScheduleWidgetState({@required this.dag});

  Dag dag;
  String currentScheduleCode = "";
  List<HourScheduleWidget> hourScheduleWidgets;

  setCurrentScheduleCode() async {
    var result = await UserPreferences().getCurrentLesson();
    if (mounted) {
      setState(() {
        currentScheduleCode = result;
      });
    }
  }

  launchURL() async {
    var url = 'http://hoornbeeck.roosterinfo.nl/index.php/?groep=' +
        currentScheduleCode;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(
        content: Text('De url kon niet worden geopend in een browser'),
        action: SnackBarAction(
          label: 'Verbergen',
          onPressed: () {
            // Some code to undo the change!
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setCurrentScheduleCode();
      List<HourScheduleWidget> hourScheduleWidgetsTemp = List();
      for (var uur in dag.uren) {
        hourScheduleWidgetsTemp.add(HourScheduleWidget(uur: uur));
      }
      setState(() {
        hourScheduleWidgets = hourScheduleWidgetsTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dag.dag,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentScheduleCode,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: (hourScheduleWidgets.length > 0)
                ? hourScheduleWidgets
                : [
                    Icon(Icons.error_outline),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Dat is jammer geen rooster, heb je vrij? Waarschijnlijk niet, deze informatie kreeg de app: \n\n" +
                            (dag.roostertekst ?? "geen informatie") +
                            "\n\n Kijk online voor meer informatie:",
                        textAlign: TextAlign.center,
                      )),
                    ),
                    FlatButton(
                      onPressed: () {
                        launchURL();
                      },
                      child: Text(
                        "hoornbeeck.roosterinfo.nl",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ])
      ],
    );
  }
}
