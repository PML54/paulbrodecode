// Official

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cartono/briceclass.dart';
import 'package:cartono/dadate.dart';

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
      title: 'St-Brice 3.02',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'St-Brice 3.02'),
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
  String mafoto = "assets/1.jpeg";
  double thiswidth = 600;
  double thisheight = 600;
  int prixClosed = 1;
  int caTheo=0;
  String prixDisplayed = "";
  String debug = "";
  String dateSelected = "2021-6-6";
  String dateSelectedPrev = "2021-6-6";
  //"https://brocabrac.fr/recherche?ou=27,60,78,95&c=bro,vgr&d=2021-11-11"
  //DateTime brocabracDate;
 // final listTables = [
  //Tables ( 1,"PML","Catalogue Peche ",1),

  Tables cetteTable =  listTables [0];

//
  List<Cartonton> listObjets = [];
  int nbTotalObjets = 0;

  //
  List<int> mesCartons = [];

  int quelCarton = 1;
  int ordreCarton = 0;
  //
  int neoPrix=0; // Prix Calculé
  int okSave=0; // activer si + ou +
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
    okSave=0;
    for (Cartonton _thisObjet in listObjets) {
      if (_thisObjet.cartonNo == quelCarton) {

        listObjetsCarton.add(_thisObjet);

        valeurCarton = valeurCarton + _thisObjet.prix;
      }
    }
    for (Tables _thisTable in listTables) {
      if (_thisTable.quelCarton== quelCarton) {
        cetteTable =_thisTable;

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

  //+++++++++++++++++++++
  void _moinsPrix() {
    setState(() {
      okSave=1;
    neoPrix = (listObjetsCarton[counterObjets].prix) - 1;
      if (neoPrix < 1) neoPrix = 1;
     listObjetsCarton[counterObjets].prix = neoPrix;
      prixClosed =  neoPrix;
      prixDisplayed = prixClosed.toString() + " €";
    });
  }

  //+++++++++++++++++++++
  void _plusPrix() {
    setState(() {
      okSave=1;
       neoPrix = listObjetsCarton[counterObjets].prix + 1;
     listObjetsCarton[counterObjets].prix = neoPrix;
      prixClosed =  neoPrix;
      prixDisplayed = prixClosed.toString() + " €";
    });
  }

  //+++++++++++++++++++++
  void _cartonApres() {
    setState(() {
      ordreCarton++;
      okSave=0;
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
      okSave=0;
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
    okSave=0; // Ps 2 fois de suite
    listObjetsCarton[counterObjets].prix = neoPrix;
    Uri url = Uri.parse("https://www.paulbrode.com/dbu.php");
    var id = listObjetsCarton[counterObjets].cleObjet.toString();
    var prix = listObjetsCarton[counterObjets].prix.toString();
    var data = {"cleobjet": id, "prix": prix,"dadate":dateSelected};
    var res = await http.post(url, body: data);
  }

  //+++++++++++++++++++++
  Future getData() async {
    Uri url = Uri.parse("https://www.paulbrode.com/db.php");
    var data = {"dadate":dateSelected};

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        okSave=0;
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
    setState(() {okSave=0;

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
  void _decrementCounter() {
    // POur chaque sous Liste listObjetsCarton
    //  On va  chercher l'image
    // Pour revrnir au début utlisons le reste de la division
    setState(() {okSave=0;

   counterObjets--;
    if (counterObjets < 0 ) counterObjets = 0;
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

caTheo=0;
    for (Cartonton _thisObjet in listObjets) {
      int thisCarton = _thisObjet.cartonNo;
      int inside = 0;
      caTheo=caTheo+_thisObjet.prix;
      for (var element in mesCartons) {

        if (element == thisCarton) inside = 1;
      }
      if (inside == 0) mesCartons.add(thisCarton);
    }
    mesCartons.sort();
  }

  //+++++++++++++++++++++
  @override
  void initState() {
    getData();
  }

  //+++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    return Scaffold(
     /* appBar: AppBar(
       // title: Text(widget.title),
      ),*/
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
                    tooltip: '-1€',
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
                    heroTag: 'plus',
                    onPressed: _plusPrix,
                    tooltip: '+1€',
                    child: const Icon(Icons.exposure_plus_1),
                  ),
                  FloatingActionButton(
                    heroTag: 'moins',
                    onPressed: updateData,
                    tooltip: 'Save',
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
              Row(
                children: [
                  FloatingActionButton(
                    heroTag: 'decrement',
                    onPressed:  _decrementCounter,
                    tooltip: dateSelected,
                    child: const Icon(Icons.arrow_back),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                          (counterObjets + 1).toString() +
                          ' / ' +
                          objetsInCarton.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          backgroundColor: Colors.white,
                          color: Colors.black),
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'increment',
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.arrow_forward),
                  ),

                ],
              ),
              Text(
                cetteTable.quiGere,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    backgroundColor: Colors.red,
                    color: Colors.black),
              ),
              Text(
                " "+cetteTable.quelTitre+" ",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    backgroundColor: Colors.white,
                    color: Colors.black),
              ),
              Text(
                "Table N°" + cetteTable.quelTable.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    backgroundColor: Colors.white10,
                    color: Colors.black),
              ),
            ],
          ),



        ],
      ),

      bottomNavigationBar: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            FloatingActionButton(
              heroTag: 'cartonavant',
              onPressed: _cartonAvant,
              tooltip: 'Au Précédent',
              child: const Icon(Icons.arrow_back),
            ),
            Text(
              "   B" +
                  quelCarton.toString() +
                  ' = ' +
                  valeurCarton.toString() +
                  ' €   ' + ' Total = '+caTheo.toString() +
                  ' €   ',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  backgroundColor: Colors.blue,
                  color: Colors.white),
            ),
            FloatingActionButton(
              heroTag: 'cartonapres',
              onPressed: _cartonApres,
              tooltip: 'Au Suivant',
              child: const Icon(Icons.arrow_forward),
            ),
            IconButton(
              // unused
              icon: const Icon(Icons.alarm),
              iconSize: 40,
              color: Colors.deepPurple,
              tooltip: 'unused',
              onPressed: () async {
                String dateSelection = await (Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (const MyDaDate()),
                    settings: const RouteSettings(

                    ),
                  ),
                ));
                setState(() {

                  dateSelectedPrev = dateSelected;
                  // NEW gestion des Null en DART
                  dateSelected = dateSelection;
                  print ("-------------->"+dateSelected);
                });
                if (dateSelectedPrev != dateSelected) var dd=1;
              },
            ),

          ]),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
