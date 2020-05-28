import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Employee> fetchEmployee() async {
  final response =
  await http.get('https://ceo-api.demo.performation.cloud/api/v1/employees/2');

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

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Employee> futureEmployee;

  @override
  void initState() {
    super.initState();
    futureEmployee = fetchEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Employee>(
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
        ),
      ),
    );
  }
}

