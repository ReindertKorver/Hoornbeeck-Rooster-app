import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';

class SchedulesWidget extends StatefulWidget {
  @override
  _SchedulesWidgetState createState() => _SchedulesWidgetState();
}

class _SchedulesWidgetState extends State<SchedulesWidget> {
  List<String> listStrings = [];
  List<Widget> listItems = [
    Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ))
  ];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  deleteItem(int index) async {
    setState(() {
      listItems = [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ))
      ];
    });
    await UserPreferences().removeClass(index);
    getItems();
  }

  selectItem(i) async {
    await UserPreferences().setCurrentLesson(listStrings[i]);
  getItems();
  }

  getItems() async {
    listStrings = await UserPreferences().getClasses();
    List<Widget> tempList = [];
    var currentScheduleCode = await UserPreferences().getCurrentLesson();
    if (listStrings[0] != "Fout") {
      for (var i = 0; i < listStrings.length; i++) {
        tempList.add(ListTile(
          leading: Icon(Icons.assignment),
          title: Text(listStrings[i] ?? ""),
          selected:
              ((listStrings[i] ?? "") == currentScheduleCode) ? true : false,
          onTap: () {
            selectItem(i);
            setState(() {});
          },
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteItem(i);
              }),
        ));
      }
    } else {
      tempList.add(ListTile(
        title: Text(listStrings[0] ?? ""),
        subtitle: Text(listStrings[1] ?? ""),
        selected: false,
        onTap: () {},
      ));
    }
    setState(() {
      listItems = tempList;
    });
  }

  Widget baseWidget = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        "Kies een rooster om te bekijken",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: AppColors.primaryColor),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        baseWidget,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 32.0, right: 32.0, top: 8.0, bottom: 0.0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    children: listItems),
              ),
            )),
          ),
        ),
      ],
    );
  }
}
