// Official

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:bricethon/fototon.dart';
import 'package:bricethon/database/briceclass.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /* It declares two optional named parameters (optional named because of {}) where
the first is of name key with type Key */

  // This widget is the root of your application.
  /* override just points out that the function is also defined in an ancestor class,
  but is being redefined to do something else in the current class.
  It's also used to annotate the implementation of an abstract method. '
  'It is optional to use but recommended as it improves readability. */
  @override

  Widget build(BuildContext context) {
    /*A BuildContext is nothing else but a reference to the location of a Widget
    within the tree structure of all the Widgets which are built.*/
    return MaterialApp(
      title: 'Saint-Brice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cartons pour Saint Brice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String mafoto = "assets/1.jpeg";

  // Réglages de l'image
  double thiswidth = 1000;
  double thisheight = 1000;

  void _changeText() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      int kifile = _counter % 2 + 1;
      mafoto = imgList[kifile];
      mafoto = 'assets/' + kifile.toString() + '.jpeg';
    });
  }
void readMysql()    {
    // ON l'appelle au démarrage de l'appli



}

  List<Cartonton> listCarton  = [];
  int nbRecords=0;

  Future getData() async {
    Uri url= Uri.parse("http://www.paulbrode.com/db.php");
    //Uri url = Uri.parse("http://francinebrode.com/db.php");
    int bb=1;
    http.Response response = await http.get(url);
    var datamysql = jsonDecode(response.body) as List;
    setState(() {
      listCarton = datamysql.map((xJson) => Cartonton.fromJson(xJson)).toList();
    });

    print(datamysql.toString());
    print(" Combien = " +listCarton.length.toString());
  }
    void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      int kifile = _counter % 32 + 1;
      mafoto = imgList[kifile];

      mafoto = 'briceton/94/' + kifile.toString() + '.jpeg';
    });
  }

  void initState() {
    getData();
    nbRecords=listCarton.length;
    print ("listCarton.length = "+ listCarton.length.toString());

  }


  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Image.network(
            mafoto,
            fit: BoxFit.fill,
            width: thiswidth,
            height: thisheight,
          ),
          Column(
            children: [
              Slider(
                label: 'Hauteur',
                activeColor: Colors.orange,
                divisions: 20,
                min: 600,
                max: 1600,
                value: thisheight,
                onChanged: (double newValue) {
                  setState(() {
                    newValue = newValue.round() as double;
                    if (newValue != thisheight) thisheight = newValue;
                  });
                },
              ),
              Slider(
                label: 'Largeur',
                activeColor: Colors.blueAccent,
                divisions: 10,
                min: 600,
                max: 1600,
                value: thiswidth,
                onChanged: (double newValue) {
                  setState(() {
                    newValue = newValue.round() as double;
                    if (newValue != thiswidth) thiswidth = newValue;
                  });
                },
              ),
              Slider(
                label: 'monlabel',
                activeColor: Colors.orange,
                divisions: 20,
                min: 0,
                max: 19,
                value: 10,
                onChanged: (double newValue) {
                  setState(() {
                    newValue = newValue.round() as double;
                  });
                },
              ),
              Slider(
                label: 'monlabel',
                activeColor: Colors.orange,
                divisions: 20,
                min: 0,
                max: 19,
                value: 10,
                onChanged: (double newValue) {
                  setState(() {
                    newValue = newValue.round() as double;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.youtube_searched_for),
                iconSize: 80,
                color: Colors.deepOrange,
                tooltip: 'brocabrac',
                onPressed: () {
                  var nbBrocabrac = 0;
                },
              ),
              IconButton(
                icon: const Icon(Icons.map_outlined),
                iconSize: 80,
                color: Colors.blue,
                tooltip: 'unused',
                onPressed: () {},
              ),
              RaisedButton(
                color: Colors.red, // background
                textColor: Colors.white, // foreground
                onPressed: () {},
                child: Text('B1'),
              ),
              RaisedButton(
                child: Text(
                  "Click Here",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _changeText,
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.grey,
              )
            ],
          ),
        ],
      ),

      bottomNavigationBar: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.youtube_searched_for),
              iconSize: 80,
              color: Colors.deepOrange,
              tooltip: 'brocabrac',
              onPressed: () {
                var nbBrocabrac = 0;
              },
            ),
            IconButton(
              icon: const Icon(Icons.map_outlined),
              iconSize: 80,
              color: Colors.blue,
              tooltip: 'unused',
              onPressed: () {},
            ),
          ]),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
