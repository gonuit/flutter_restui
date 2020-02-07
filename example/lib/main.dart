import 'package:flutter/material.dart';

import 'package:example/example_screen.dart';
import 'package:example/example_api.dart';
import 'package:rest_ui/rest_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestUiProvider<ExampleApi>(
      create: (BuildContext context) => ExampleApi(
        uri: Uri.parse("https://picsum.photos"),
        link: HeadersMapperLink([])..chain(DebugLink()),
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
