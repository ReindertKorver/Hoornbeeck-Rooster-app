import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/BLL/ScheduleData.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/InternetConnection.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Info.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleViewerWidget/CurrentScheduleWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/ScheduleViewerWidget/SchedulesWidget.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Settings.dart';
import 'package:hoornbeeck_rooster_info_app/Widgets/Setup/SetupWidget.dart';
import 'package:hoornbeeck_rooster_info_app/DAL/UserPreferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
class MainWidget extends StatefulWidget {
  MainWidget({this.updateUI});
  final VoidCallback updateUI;
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new 
        GlobalKey<ScaffoldState>();
  Widget body = Container();
  String title = "Rooster";
  IconData icon = Icons.event;
  int currentIndex = 0;
  Text latestUpdate = Text((ScheduleData.lastUpdate != null)
      ? ScheduleData.lastUpdateFormatter.format(ScheduleData.lastUpdate)
      : "geen");
  // hieronder selecteerd hij welk screen hij laat zien. 0 = huidige rooster, 1 = je roosters
  List<Widget> screens = [CurrentScheduleWidget(), SchedulesWidget()];
  List<String> screenTitles = ["Rooster", "Roosters"];
  List<IconData> screenIcons = [Icons.event, Icons.event_note];
  StreamSubscription<ConnectivityResult> subscription;
  bool isConnected = true;
  Widget connectionIcon = IconButton(
  icon: Icon(Icons.network_wifi),
  tooltip: 'Verbonden met een netwerk!',
  onPressed: () {
    Fluttertoast.showToast(
        msg: "Verbonden met een netwerk!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  },
  );
  List<String> roosters;
  selectItem(i) async {
    await UserPreferences().setCurrentLesson(i);
    bottomSheetBuilder();
  }
  onRefresh(){
    setScreen(0);
  }
  setScreen(int index) {
    setState(() {
      body = screens[index];
      title = screenTitles[index];
      icon = screenIcons[index];
      currentIndex = index;
      latestUpdate = Text(
          (ScheduleData.lastUpdate != null)
              ? ScheduleData.lastUpdateFormatter.format(ScheduleData.lastUpdate)
              : "geen",
          style: TextStyle(color: AppColors.secondaryTextColor));
      
    });
  }

  List<Widget> roostersBottomSheetItems = [];
  bottomSheetBuilder() async {
    roostersBottomSheetItems = [
      ListTile( 
          leading: Icon(Icons.edit),
          title: Text('Wijzig roosters'),
          onTap: () {
            setScreen(1);
            Navigator.pop(context);
          }),
      ListTile(
          leading: Icon(Icons.add),
          title: Text('Rooster Toevoegen'),
          onTap: () {
            setScreen(1);
            Navigator.pop(context);
          }),
      Divider(),
    ];

    roosters = await UserPreferences().getClasses();

    for (var item in roosters) {
      roostersBottomSheetItems.add(ListTile(
        title: Text(item),
        onTap: () {
        selectItem(item);
         
         
         Navigator.pop(context);
         
         setScreen(1);
         Future.delayed(const Duration(milliseconds: 50),() {
          setScreen(0);
         });
         
         
        },
      ));
    }
  }

  roostersBottomSheet() {
    print("object pressed");
    showModalBottomSheet(
        
        context: context,
        builder: (context) {
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: roostersBottomSheetItems,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    subscription = new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      onConnectionChangeEvent();
    });
    onConnectionChangeEvent();
    bottomSheetBuilder();
  }

  onConnectionChangeEvent() async {
    bool result = await InternetConnection.checkConnection();
    if (result != isConnected) {
      if (result) {
        setState(() {
          isConnected = result;
          connectionIcon = Icon(
            Icons.signal_wifi_4_bar,
            color: AppColors.backgroundTextColor,
          );
        });
      } else {
        setState(() {
          isConnected = result;
          connectionIcon = Icon(
            Icons.signal_wifi_off,
            color: AppColors.warningColor,
            
          );
        });
      }
    }
    if (mounted) {
      setState(() {
        body = screens[currentIndex];
        title = screenTitles[currentIndex];
        icon = screenIcons[currentIndex];
      });
    }
    if (isConnected) {
      setState(() {
        latestUpdate = Text(
            (ScheduleData.lastUpdate != null)
                ? ScheduleData.lastUpdateFormatter
                    .format(ScheduleData.lastUpdate)
                : ScheduleData.lastUpdateFormatter.format(DateTime.now()),
            style: TextStyle(color: AppColors.secondaryTextColor));
      });
    } else {
      setState(() {
        latestUpdate = Text(
            (ScheduleData.lastUpdate != null)
                ? ScheduleData.lastUpdateFormatter
                    .format(ScheduleData.lastUpdate)
                : "geen",
            style: TextStyle(color: AppColors.secondaryTextColor));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: (currentIndex == 1)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: AppColors.actionTextColor,
                  size: 30.0,
                ),
                backgroundColor: AppColors.actionColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetupWidget(
                              isFirstPage: false,
                            )),
                  );
                },
              ),
            )
          : null,
      body: Container(
          color: AppColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Container(
              child: body,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: AppColors.foregroundColor,
              ),
            ),
          )),
      
      bottomNavigationBar: Container(
        color: AppColors.backgroundColor,
        child: BottomAppBar(
            color: AppColors.foregroundColor,
            shape: CircularNotchedRectangle(),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                    child: FlatButton(
                      color: AppColors.foregroundColor,
                      textColor: AppColors.primaryTextColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.event,
                              color: (currentIndex == 0)
                                  ? AppColors.actionColor
                                  : Colors.grey[400],
                              size: 30.0),
                          Text(
                            "Rooster",
                            style: TextStyle(
                                color: (currentIndex == 0)
                                    ? AppColors.actionColor
                                    : Colors.grey[400]),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setScreen(0);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                    child: FlatButton(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.event_note,
                            color: (currentIndex == 1)
                                ? AppColors.actionColor
                                : Colors.grey[400],
                            size: 30.0,
                          ),
                          //
                          Text("Roosters",
                              style: TextStyle(
                                  color: (currentIndex == 1)
                                      ? AppColors.actionColor
                                      : Colors.grey[400])),
                        ],
                      ),
                      onPressed: () {
                        roostersBottomSheet();
                      },
                    ),
                  ),
                ])),
      ),
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(
              color: AppColors.backgroundTextColor,
            )),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: connectionIcon,
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.foregroundColor,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(
                                  side: BorderSide(color: Colors.white))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                                "assets/Resources/Images/logo.png",
                                fit: BoxFit.contain,
                                height: 60.0,
                                width: 60.0),
                          )),
                    ),
                    Text(
                      'Hoornbeeck Rooster App 2.0',
                      style: TextStyle(
                        color: AppColors.backgroundTextColor,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.event,
                  color: (currentIndex == 0)
                      ? AppColors.actionColor
                      : AppColors.primaryTextColor,
                ),
                title: Text('Rooster',
                    style: TextStyle(
                      color: (currentIndex == 0)
                          ? AppColors.actionColor
                          : AppColors.primaryTextColor,
                    )),
                onTap: () {
                  setScreen(0);
                  Navigator.pop(context);
                },
                selected: (currentIndex == 0) ? true : false,
              ),
              ListTile(
                leading: Icon(
                  Icons.event_note,
                  color: (currentIndex == 1)
                      ? AppColors.actionColor
                      : AppColors.primaryTextColor,
                ),
                title: Text('Roosters',
                    style: TextStyle(
                      color: (currentIndex == 1)
                          ? AppColors.actionColor
                          : AppColors.primaryTextColor,
                    )),
                onTap: () {
                  setScreen(1);
                  Navigator.pop(context);
                },
                selected: (currentIndex == 1) ? true : false,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: AppColors.primaryTextColor,
                ),
                title: Text('Info',
                    style: TextStyle(color: AppColors.primaryTextColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Info()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: AppColors.primaryTextColor,
                ),
                title: Text('Instellingen',
                    style: TextStyle(color: AppColors.primaryTextColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(
                              updateUI: widget.updateUI,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
