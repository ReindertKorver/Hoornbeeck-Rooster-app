import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/CalendarCodeAPIConnection.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ListItem.dart';

class SetupWidget extends StatefulWidget {
  @override
  _SetupWidgetState createState() => _SetupWidgetState();
}

class _SetupWidgetState extends State<SetupWidget> {
  String searchValue;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = new FocusNode();
  String selectedItem ;
  List<Widget> searchResultList = [
    Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Typ een zoekterm om te zoeken"),
    ))
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChange);
  }

  void selectItem(String code) {
setState(() {
  selectedItem=code;
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
            onTap: (){selectItem(item["roostercode"]);},
          ));
        }
      } catch (Exception) {
        listItems=null;
        setState(() {
          searchResultList = listItems ??
              [Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Er is een fout opgetreden, probeer opnieuw"),
                  ))];
        });
      }
      setState(() {
        searchResultList = (listItems!=null&&listItems.length>0)?listItems :
            [Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Kan gezochte niet vinden"),
            ))];
      });
    }
    print("changed");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                "Welkom",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "Zoek hieronder een klas/groep of docent code",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 1.0),
              ),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 32.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                            primaryColor: Colors.white,
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
                              borderRadius: BorderRadius.circular(25.0)),
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(width: 2.0, color: Colors.white),
                        color: AppColors.primaryColor,
                        shape: BoxShape.rectangle),
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
            ),
            ButtonBar(
              children: <Widget>[
                Text(selectedItem??"Geen geselecteerd"),
                RawMaterialButton(
                  onPressed: () {},
                  child: Text("Bevestigen"),
                  fillColor: Colors.white,
                  textStyle: TextStyle(color: AppColors.primaryColor),
                  splashColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
