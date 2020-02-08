import 'package:example/screens/example_screen.dart';
import 'package:example/screens/state_management/example_state_management_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restui example app")),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            RaisedButton(
              child: const Text("Api example"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExampleScreen(),
                  ),
                );
              },
            ),
            RaisedButton(
              child: const Text("State management + api example"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExampleStateManagementScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
