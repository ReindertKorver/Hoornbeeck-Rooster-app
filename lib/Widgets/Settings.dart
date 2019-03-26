import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/SettingsWidgets/ColorSelector.dart';

class Settings extends StatefulWidget {
  Settings({this.updateUI});
  final VoidCallback updateUI;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.foregroundColor,
      appBar:   AppBar(
      title: Text(
      "Instellingen",
      style: TextStyle(color: AppColors.backgroundTextColor),
    ),),
      body: ListView(
        children: <Widget>[
        ListTile(
          onTap: (){  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ColorSelector(updateUI: widget.updateUI,)),
          );},
          title: Text("Kleuren",style: TextStyle(color: AppColors.primaryTextColor)),
          subtitle: Text("Wijzig de kleuren van de applicatie",style: TextStyle(color: AppColors.secondaryTextColor)),
        ),
      ],),
    );
  }
}
