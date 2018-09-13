import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';

class ListItem extends StatefulWidget {
  ListItem({this.onTap,this.subTitle,this.title});
  String title;
  String subTitle;
  Function onTap;
  @override
  _ListItemState createState() => _ListItemState(onTap: onTap,subTitle: subTitle,title: title);
}

class _ListItemState extends State<ListItem> {
  _ListItemState({this.onTap,this.subTitle,this.title});
  String title;
  String subTitle;
  Function onTap;
  Color color=AppColors.primaryColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTap();
      },


      subtitle: Text(subTitle),
      title: Text(title),
    );
  }
}
