import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:restui/restui.dart';

import 'example_api.dart';
import 'example_graphql_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestuiProvider<ExampleGraphqQlApi>(
      apiBuilder: (BuildContext context) => ExampleGraphqQlApi(
        uri: Uri.parse("https://graphql-pokemon.now.sh"),
        link: DebugLink(
          printRequestHeaders: true,
          printRequestBody: true,
          printResponseBody: true,
        ),
      ),
      child: RestuiProvider<ExampleApi>(
        apiBuilder: (BuildContext context) => ExampleApi(
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
      ),
    );
  }
}
