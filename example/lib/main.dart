import 'package:example/screens/home_screen.dart';
import 'package:example/screens/state_management/photo_store.dart';
import 'package:flutter/material.dart';

import 'package:restui/restui.dart';

import 'example_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestuiProvider<ExampleApi>(
      apiBuilder: (BuildContext context) => ExampleApi(
        stores: <ApiStore>[
          PhotoStore(),
        ],
        uri: Uri.parse("https://picsum.photos"),
        link: HeadersMapperLink(['connection'], debug: true)
          ..chain(DebugLink(printResponseBody: true)),
      ),
      child: MaterialApp(
        title: 'Flutter RestUI example app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
