import 'package:example/screens/example_screen.dart';
import 'package:flutter/material.dart';

import 'example_graphql_screen/example_graphql_screen.dart';

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
              child: const Text("Graphql api example"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GraphqlExampleScreen(),
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
