import 'dart:async';
import 'dart:convert';

import 'package:cardoverviewpoc/PatientDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PatientDetailPage.dart';
import 'MedicineDetailPage.dart';
import 'BedDetailPage.dart';


Future<Employee> fetchEmployee() async {
  final response = await http
      .get('https://ceo-api.demo.performation.cloud/api/v1/employees/2');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Employee.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Employee');
  }
}

class Employee {
  final String name_first;
  final String name_last;
  final int id;

  Employee({this.name_first, this.id, this.name_last});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name_first: json['name_first'],
      id: json['id'],
      name_last: json['name_last'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  Future<Employee> futureEmployee = fetchEmployee();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Directeur app'),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.redAccent,
                  width: 1.0,

                ),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),

              child: Container(

                child: InkWell(

                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => PatientDetailPage()));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Patiënten'),
                        subtitle: Text('Zie hier uw overzicht van de patienten'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BedDetailPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.local_hotel),
                      title: Text('Bedden'),
                      subtitle: Text('Zie hier uw overzicht van de bedden'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MedicineDetailPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.kitchen),
                      title: Text('Medicijnen'),
                      subtitle: Text('Zie hier uw overzicht van de medicijnen'),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<Employee>(
              future: futureEmployee,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.name_first);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        )),
      ),
    );
  }
}
