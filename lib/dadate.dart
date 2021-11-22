import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Selectionner la Date de Début',
      home: MyDaDate(),
    );
  }
}

class MyDaDate extends StatefulWidget {
  const MyDaDate({Key? key}) : super(key: key);

  @override
  _MyDaDateState createState() => _MyDaDateState();
}

class _MyDaDateState extends State<MyDaDate> {
  DateTime currentDate = DateTime.now();
var finalDate;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        finalDate = pickedDate.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DatePicker"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(currentDate.toString()),
            ElevatedButton(
              child: const Text('Select date'),
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              onPressed: () =>_selectDate(context),
            ),
            ElevatedButton(
              child: const Text('back'),
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              onPressed: () {
                Navigator.pop(context, finalDate);
              },
            ),

          ],
        ),
      ),
    );
  }
}