import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';

class Settings extends StatefulWidget {
  Settings({this.updateUI});
  final VoidCallback updateUI;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color pickerColor = AppColors.actionColor;

  ValueChanged<Color> onColorChanged;
  int colorIndex = 0;

  List<Color> colors = [
    AppColors.actionColor,
    AppColors.actionTextColor,
    AppColors.primaryTextColor,
    AppColors.secondaryTextColor,
    AppColors.backgroundColor,
    AppColors.backgroundTextColor,
    AppColors.foregroundColor,
    AppColors.warningColor,
  ];

  changeColor(Color color, int index) {
    print("changed ${index.toString()} to" + color.toString());
    setState(() {
      colors[index] = color;
    });
    setState(() => pickerColor = color);
  }

  changeColorPicker(Color color) {
    setState(() => pickerColor = color);
  }

  fabPress() async {
    print("pressed");
    if (mounted) {
      setState(() {
        fabButton = FloatingActionButton.extended(
          onPressed: () {},
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppColors.actionTextColor),
            ),
          ),
          label: Text(
            "Laden...",
            style: TextStyle(color: AppColors.actionTextColor),
          ),
        );
      });
    }
    await AppColors.setColors(colors);
    setSaveButton();
    widget.updateUI();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        colors = [
          AppColors.actionColor,
          AppColors.actionTextColor,
          AppColors.primaryTextColor,
          AppColors.secondaryTextColor,
          AppColors.backgroundColor,
          AppColors.backgroundTextColor,
          AppColors.foregroundColor,
          AppColors.warningColor,
        ];
      });
    }
    setSaveButton();
  }

  setSaveButton() {
    if (mounted) {
      setState(() {
        fabButton = FloatingActionButton.extended(
            onPressed: fabPress,
            icon: Icon(Icons.save,color: AppColors.actionTextColor),
            label: Text("Opslaan",style: TextStyle(color: AppColors.actionTextColor),));
      });
    }
  }

  FloatingActionButton fabButton;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Instellingen",
      theme: ThemeData(
        primaryColorDark: AppColors.backgroundColor,
        primaryColor: AppColors.backgroundColor,
        accentColor: AppColors.actionColor,
      ),
      home: Scaffold(
        floatingActionButton: fabButton,
        appBar: AppBar(
          title: Text(
            "Instellingen",
            style: TextStyle(color: AppColors.backgroundTextColor),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.backgroundTextColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container(
          color: AppColors.foregroundColor,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Container(

                child: Column(children: [
                  Text("Kies een kleur",
                      style: TextStyle(color: AppColors.primaryTextColor)),
                  Divider(),
                  SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColorPicker,
                      enableLabel: false,
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                ]),
              ),
            ),
            Text(
              "Kleuren",
              style: TextStyle(color: AppColors.primaryTextColor),
            ),
            Divider(),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 16 / 10),
                children: <Widget>[
                  SettingsColorListItem(
                      title: "Actie",
                      color: colors[0],
                      onTap: () {
                        setState(() {
                          colorIndex = 0;
                        });
                        changeColor(pickerColor, 0);
                      }),
                  SettingsColorListItem(
                      title: "Actietekst",
                      color: colors[1],
                      onTap: () {
                        setState(() {
                          colorIndex = 1;
                        });
                        changeColor(pickerColor, 1);
                      }),
                  SettingsColorListItem(
                      title: "Tekst",
                      color: colors[2],
                      onTap: () {
                        setState(() {
                          colorIndex = 2;
                        });
                        changeColor(pickerColor, 2);
                      }),
                  SettingsColorListItem(
                      title: "Subtekst",
                      color: colors[3],
                      onTap: () {
                        setState(() {
                          colorIndex = 3;
                        });
                        changeColor(pickerColor, 3);
                      }),
                  SettingsColorListItem(
                      title: "Achter",
                      color: colors[4],
                      onTap: () {
                        setState(() {
                          colorIndex = 4;
                        });
                        changeColor(pickerColor, 4);
                      }),
                  SettingsColorListItem(
                      title: "Achtertekst",
                      color: colors[5],
                      onTap: () {
                        setState(() {
                          colorIndex = 5;
                        });
                        changeColor(pickerColor, 5);
                      }),
                  SettingsColorListItem(
                      title: "Voor",
                      color: colors[6],
                      onTap: () {
                        setState(() {
                          colorIndex = 6;
                        });
                        changeColor(pickerColor, 6);
                      }),
                  SettingsColorListItem(
                      title: "Waarschuwing",
                      color: colors[7],
                      onTap: () {
                        setState(() {
                          colorIndex = 7;
                        });
                        changeColor(pickerColor, 7);
                      }),
                  Container(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class SettingsColorListItem extends StatefulWidget {
  SettingsColorListItem({this.title, this.color, this.onTap});

  final String title;
  final Color color;
  final GestureTapCallback onTap;

  @override
  SettingsColorListItemState createState() {
    return new SettingsColorListItemState();
  }
}

class SettingsColorListItemState extends State<SettingsColorListItem> {
  bool collapsed = true;

  ValueChanged<Color> onColorChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.foregroundColor,
      child: InkWell(
        onTap: widget.onTap,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 35.0,
                  width: 35.0,
                  decoration: ShapeDecoration(
                      color: widget.color,
                      shadows: [BoxShadow(color: Colors.black)],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
              ],
            ),
          ),
          subtitle: Text(
            widget.title,
            style: TextStyle(color: AppColors.primaryTextColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
