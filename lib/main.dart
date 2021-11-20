// Official

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cartono/briceclass.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Saint Brice  2.03 '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Debug sur Plateforme

  // Réglages de l'image
  String mafoto = "assets/1.jpeg";
  double thiswidth = 1000;
  double thisheight = 1000;
  int prixClosed = 1;
  String prixDisplayed = "";
  String debug = "";

//
  List<Cartonton> listObjets = [];
  int nbTotalObjets = 0;

  //
  List<int> mesCartons = [];
  int nbCartons = 15; // Nb Cartons
  int quelCarton = 1;
  int ordreCarton = 0;

//
  List<Cartonton> listObjetsCarton = []; // reduce
  int counterObjets = 0;
  int objetsInCarton = 1;
  int valeurCarton = 0;

  //+++++++++++++++++++++
  void selectUnCarton() {
    // C'est le carton Actif --> quelCarton
    listObjetsCarton.clear();
    valeurCarton = 0;
    for (Cartonton _thisObjet in listObjets) {
      if (_thisObjet.cartonNo == quelCarton) {
        listObjetsCarton.add(_thisObjet);
        valeurCarton = valeurCarton + _thisObjet.prix;
      }
    }

    setState(() {
      listObjetsCarton.sort((a, b) => a.imageNo.compareTo(b.imageNo));
      objetsInCarton = listObjetsCarton.length;
      counterObjets = 0;
      mafoto = 'briceton/' +
          quelCarton.toString() +
          '/' +
          (counterObjets + 1).toString() +
          '.jpeg';
      prixClosed = listObjetsCarton[counterObjets].prix;
      prixDisplayed = prixClosed.toString() + " €";
    });
  }

  //+++++++++++++++++++++
  void _fake() {}

  //+++++++++++++++++++++


  //+++++++++++++++++++++
  void _moinsPrix() {
    int neoPrix = (listObjetsCarton[counterObjets].prix) - 1;
    if (neoPrix < 1) neoPrix = 1;
    listObjetsCarton[counterObjets].prix = neoPrix;
    setState(() {
      prixClosed = listObjetsCarton[counterObjets].prix;
      prixDisplayed = prixClosed.toString() + " €";
    });
  }

  //+++++++++++++++++++++
  void _plusPrix() {
      int neoPrix = listObjetsCarton[counterObjets].prix + 1;
    listObjetsCarton[counterObjets].prix = neoPrix;
    setState(() {
      prixClosed = listObjetsCarton[counterObjets].prix;
      prixDisplayed = prixClosed.toString() + " €";
    });
  }

  //+++++++++++++++++++++
  void _cartonApres() {
    setState(() {
      ordreCarton++;
      if (ordreCarton >= mesCartons.length) {
        ordreCarton = 0;
      }
      quelCarton = mesCartons[ordreCarton];

      selectUnCarton();
      prixDisplayed = "?";
    });
  }

  //+++++++++++++++++++++
  void _cartonAvant() {
    setState(() {
      ordreCarton--;
      if (ordreCarton < 0) {
        ordreCarton = 0;
      }
      quelCarton = mesCartons[ordreCarton];
      selectUnCarton();
      prixDisplayed = "?";
    });
  }

  //***********
  void updateData() async {
    Uri url = Uri.parse("http://www.paulbrode.com/dbu.php");
    var id = listObjetsCarton[counterObjets].cleObjet.toString();
    var prix = listObjetsCarton[counterObjets].prix.toString();
    var data = {"cleobjet": id, "prix": prix};
    var res = await http.post(url, body: data);
  }

  //+++++++++++++++++++++
  Future getData() async {
    Uri url = Uri.parse("http://www.paulbrode.com/db.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listObjets =
            datamysql.map((xJson) => Cartonton.fromJson(xJson)).toList();
        _getListCarton();
        ordreCarton = 0;
        quelCarton = mesCartons[0];
        selectUnCarton();
      });
    } else {}
  }

  //+++++++++++++++++++++
  void _incrementCounter() {
    // POur chaque sous Liste listObjetsCarton
    //  On va  chercher l'image
    // Pour revrnir au début utlisons le reste de la division
    setState(() {
      counterObjets++;
      if (counterObjets >= objetsInCarton) counterObjets = 0;
      mafoto = 'briceton/' +
          quelCarton.toString() +
          '/' +
          (counterObjets + 1).toString() +
          '.jpeg';

      prixClosed = listObjetsCarton[counterObjets].prix;
      prixDisplayed = "?";
    });
  }

  //+++++++++++++++++++++
  void _getListCarton() {
    mesCartons.clear();
    int i = 0;

    for (Cartonton _thisObjet in listObjets) {
      _thisObjet.kikey = i++;

      int thisCarton = _thisObjet.cartonNo;
      int inside = 0;

      for (var element in mesCartons) {
        if (element == thisCarton) inside = 1;
      }
      if (inside == 0) mesCartons.add(thisCarton);
    }
    mesCartons.sort();
  }

  //+++++++++++++++++++++
  void initState() {
    getData();
    nbTotalObjets = listObjets.length; // Pas used
  }

  //+++++++++++++++++++++
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
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
              RaisedButton(
                color: Colors.red, // background
                textColor: Colors.white, // foreground
                onPressed: () {},
                child: Text(listObjetsCarton[counterObjets].titre),
              ),
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: _moinsPrix,
                    tooltip: 'Au Suivant',
                    child: const Icon(Icons.exposure_neg_1),
                  ),
                  ElevatedButton(
                    child: Text(prixDisplayed),
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      setState(() {
                        prixClosed = listObjetsCarton[counterObjets].prix;
                        prixDisplayed = prixClosed.toString() + " €";
                      });
                    },
                  ),
                  FloatingActionButton(
                    onPressed: _plusPrix,
                    tooltip: 'Au Suivant',
                    child: const Icon(Icons.exposure_plus_1),
                  ),
                  FloatingActionButton(
                    onPressed: updateData,
                    tooltip: 'Save',
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "   Objet N° " +
                      (counterObjets +1 ).toString() +
                      ' / ' +
                      objetsInCarton.toString() ,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      backgroundColor: Colors.black,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _cartonAvant,
              tooltip: 'Au Précédent',
              child: const Icon(Icons.arrow_back),
            ),
            Text(
              "   B" +
                  quelCarton.toString() +
                  ' = ' +
                  valeurCarton.toString() +
                  ' €   ' ,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  backgroundColor: Colors.blue,
                  color: Colors.white),
            ),
            FloatingActionButton(
              onPressed: _cartonApres,
              tooltip: 'Au Suivant',
              child: const Icon(Icons.arrow_forward),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
