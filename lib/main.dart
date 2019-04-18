import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'LoginRegister.dart';
import 'Home.dart';
import 'Authentication.dart';

import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q-A meetup!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //home: MyHomePage(title: 'Q-A meetup!'),
      //home: LoginRegisterPage(),
      //home: Home(),
      home: Mapping(
        auth: Auth(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        //tooltip: 'Increment',

        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {}));
        },

        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
