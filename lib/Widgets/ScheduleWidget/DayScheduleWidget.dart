import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/ScheduleData.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Entities/Dag.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleWidget/HourScheduleWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class DayScheduleWidget extends StatefulWidget {
  DayScheduleWidget(this.dateTime, {@required this.dag, @required this.onRefresh,@required this.refreshKey, });
  final RefreshCallback onRefresh;
  final String dateTime;
  final Dag dag;
  final refreshKey;

  @override
  _DayScheduleWidgetState createState() => _DayScheduleWidgetState(onRefresh:onRefresh,dag: dag,refreshKey:refreshKey,);
}

class _DayScheduleWidgetState extends State<DayScheduleWidget> {
  _DayScheduleWidgetState(  {this.onRefresh,@required this.dag,@required this.refreshKey, });
final RefreshCallback onRefresh;
  Dag dag;
  String currentScheduleCode = "";
  List<HourScheduleWidget> hourScheduleWidgets;
  final refreshKey;
  setCurrentScheduleCode() async {
    var result = await UserPreferences().getCurrentLesson();
    if (mounted) {
      setState(() {
        currentScheduleCode = result;
      });
    }
  }
Widget refreshWidget=Row();
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
  showRefreshMessage()async{
    final snackBar = SnackBar(
      content: Text('Laatste rooster update: '+ScheduleData.lastUpdateFormatter.format(ScheduleData.lastUpdate)),
      action: SnackBarAction(
        label: 'Verbergen',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);

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
    return RefreshIndicator(
      onRefresh: (){return onRefresh()..whenComplete( showRefreshMessage);},
      child: Container(color: AppColors.foregroundColor,
        child: ListView(
          children: <Widget>[
            refreshWidget,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dag.dag,
                    textAlign: TextAlign.left,style: TextStyle(color: AppColors.primaryTextColor)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentScheduleCode,
                    textAlign: TextAlign.left,style: TextStyle(color: AppColors.primaryTextColor)
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
                        Icon(Icons.error_outline,color: AppColors.warningColor,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "Dat is jammer geen rooster, heb je vrij? Waarschijnlijk niet, deze informatie kreeg de app: \n\n" +
                                (dag.roostertekst ?? "geen informatie") +
                                "\n\n Kijk online voor meer informatie:",
                            textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryTextColor)
                          )),
                        ),
                        FlatButton(
                          onPressed: () {
                            launchURL();
                          },
                          child: Text(
                            "hoornbeeck.roosterinfo.nl",
                            style: TextStyle(color:AppColors.actionColor,),
                          ),
                        ),
                      ])
          ],
        ),
      ),
    );
  }
}
