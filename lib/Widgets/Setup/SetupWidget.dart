import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/CalendarCodeAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Items/ListItem.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Main/MainWidget.dart';

class SetupWidget extends StatefulWidget {
  SetupWidget({@required this.isFirstPage});

  final bool isFirstPage;

  @override
  _SetupWidgetState createState() =>
      _SetupWidgetState(isFirstPage: isFirstPage);
}

class _SetupWidgetState extends State<SetupWidget> {
  _SetupWidgetState({this.isFirstPage});

  bool isFirstPage;
  String searchValue;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = new FocusNode();
  String selectedItem;

  List<Widget> searchResultList = [
    Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Typ een zoekterm om te zoeken",
          style: TextStyle(color: AppColors.primaryTextColor)),
    ))
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChange);
  }

  void selectItem(String code) {
    setState(() {
      selectedItem = code;
    });
  }

  void onSearchChange() async {
    if (searchController.text != null && searchController.text != "") {
      setState(() {
        searchResultList = [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ))
        ];
      });
      List<dynamic> listResult =
          await CalendarCodeAPIConnection().searchCode(searchController.text);
      List<Widget> listItems = List();
      try {
        for (var item in listResult) {
          listItems.add(ListItem(
            title: item["roostercode"],
            subTitle: item["type"],
            onTap: () {
              selectItem(item["roostercode"]);
            },
          ));
        }
      } catch (Exception) {
        listItems = null;
        setState(() {
          searchResultList = listItems ??
              [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Er is een fout opgetreden, probeer opnieuw",
                      style: TextStyle(color: AppColors.primaryTextColor)),
                ))
              ];
        });
      }
      setState(() {
        searchResultList = (listItems != null && listItems.length > 0)
            ? listItems
            : [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Kan gezochte niet vinden",
                      style: TextStyle(color: AppColors.primaryTextColor)),
                ))
              ];
      });
    }
    print("changed");
  }

  goBack() {
    Navigator.pop(context);
  }

  acceptCode() async {
    var result = await UserPreferences().addClass(selectedItem);
    if (result == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainWidget()),
      );
    } else {
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text(result),
//        action: SnackBarAction(label: "Verbergen", onPressed: (){}),
//      ));
      setState(() {
        searchResultList = [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(result,
                style: TextStyle(color: AppColors.primaryTextColor)),
          ))
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0,bottom: 30.0),
                child: Text(
                  "Zoek hieronder een klas/groep of docent code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: AppColors.backgroundTextColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: AppColors.foregroundColor,
                  child: Column(
                    children: <Widget>[
                      Form(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32.0, right: 32.0, top: 32.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  primaryColor: AppColors.actionColor,
                                ),
                                child: TextFormField(
                                  controller: searchController,
                                  autofocus: false,
                                  focusNode: searchFocus,
                                  decoration: InputDecoration(
                                    labelText: "Zoeken",
                                    prefixIcon: Icon(
                                      Icons.search,
                                    ),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  children: searchResultList),
                            ),
                          )),
                        ),
                      ), ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (!isFirstPage)
                              ? RawMaterialButton(
                            onPressed: () {
                              //Todo: add error catching and show the message
                              goBack();
                            },
                            child: Text("Terug"),
                            fillColor: AppColors.actionColor,
                            textStyle:
                            TextStyle(color: AppColors.actionTextColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          )
                              : Container(),
                          Text(selectedItem ?? "Geen geselecteerd"),
                          RawMaterialButton(
                            onPressed: () {
                              if (selectedItem != null) {
                                acceptCode();
                              } else {}
                            },
                            child: Text("Bevestigen"),
                            fillColor: AppColors.actionColor,
                            textStyle: TextStyle(color: AppColors.actionTextColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
