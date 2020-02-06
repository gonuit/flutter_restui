import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:example/example_screen.dart';
import 'package:example/example_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ExampleApi>(
      create: (_) => ExampleApi(uri: Uri.parse("https://picsum.photos")),
      dispose: (_, api) => api.dispose(),
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
