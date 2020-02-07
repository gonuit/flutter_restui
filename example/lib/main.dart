import 'package:flutter/material.dart';

import 'package:example/example_screen.dart';
import 'package:example/example_api.dart';
import 'package:restui/restui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestuiProvider<ExampleApi>(
      apiBuilder: (BuildContext context) => ExampleApi(
        uri: Uri.parse("https://picsum.photos"),
        link: HeadersMapperLink(['connection'], debug: true)
          ..chain(DebugLink(printResponseHeaders: true)),
      ),
      child: MaterialApp(
        title: 'Flutter RestUI example app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ExampleScreen(),
      ),
    );
  }
}
