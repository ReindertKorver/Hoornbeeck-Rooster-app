import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ListItem.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Setup/SetupWidget.dart';

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

  getItems() async {
    listStrings = await UserPreferences().getClasses();
    List<Widget> tempList = [];
    if (listStrings[0] != "Fout") {
      for (var i = 0; i < listStrings.length; i++) {
        tempList.add(ListTile(
          leading: Icon(Icons.assignment),
          title: Text(listStrings[i]),
          onTap: () {},
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteItem(i);
              }),
        ));
      }
    } else {
      tempList.add(ListTile(
        title: Text(listStrings[0]),
        subtitle: Text(listStrings[1]),
        onTap: () {},
      ));
    }
    setState(() {
      listItems = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 0.0),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0,right: 16.0),
          child: FloatingActionButton.extended(label:Text("Nieuw rooster toevoegen",style: TextStyle(color: AppColors.primaryColor),),icon:Icon(Icons.add_circle,color: AppColors.primaryColor,) ,backgroundColor: AppColors.accentColor,onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SetupWidget()),
            );
          },),
        ),
      ],
    );
  }
}
