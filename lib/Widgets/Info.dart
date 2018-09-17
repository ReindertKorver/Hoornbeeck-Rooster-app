import 'package:flutter/material.dart';
import 'package:hoornbeeck_rooster_info_app/Resources/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  launchURL() async {
    var url = 'https://github.com/ReindertKorver/Hoornbeeck-Rooster-app';
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
  launchEmail() async {
    var url = 'mailto:ReindertKorver@gmail.com?subject=HoornbeeckRoosterApp-Probleem&body=%20';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(
        content: Text('De email app kon niet worden geopend'),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Info",
      theme: ThemeData(
        primaryColorDark: AppColors.primaryColorDark,
        primaryColor: AppColors.primaryColor,
        accentColor: AppColors.accentColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Info"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Gemaakt door: Reindert Korver"),
                  ),
                  leading: Icon(Icons.person),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Vindt de code op Github"),
                      FlatButton(
                          onPressed: () {
                            launchURL();
                          },
                          child: Text(
                            "GitHub.com/reindertkorver",
                            style: TextStyle(color: AppColors.primaryColor),
                          ))
                    ],
                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Let op!"),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Ik wil niet verantwoordelijk zijn voor alle mensen die zogenaamd te laat komen door deze app, bij het gebruiken van de app accepteer je dat het mogelijk is dat er fouten kunnen zijn onstaan bij het ophalen van het rooster."),
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Dit is niet de originele app"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Al is dit niet de originele roosterinfo app, toch zal de informatie als het goed is grotendeels hetzelfde zijn, dit komt doordat allebij de app's dezelfde data gebruiken."),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Problemen"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Wanneer er zich problemen voordoen binnen de app meld dit dan niet aan anderen dan mijzelf via ondestaande knop, zo kan het zo snel mogelijk opgelost worden. "),
                  ),
                ),
              ),
              FlatButton(onPressed: (){launchEmail();}, child: Text("Probleem melden!", style: TextStyle(color: Colors.red),))
            ],
          ),
        ),
      ),
    );
  }
}
