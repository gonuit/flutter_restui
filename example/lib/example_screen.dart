import 'package:flutter/material.dart';
import 'package:rest_ui/rest_ui.dart';

import 'example_photo_model.dart';
import 'example_api.dart';

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final GlobalKey<QueryState<ExamplePhotoModel, ExampleApi>> _queryKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Api example"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "This image is fetched only once and "
                  "can be refetched by pressing FAB button:",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Query<ExamplePhotoModel, ExampleApi>(
                  key: _queryKey,
                  callBuilder: (ExampleApi api) => api.photos.getRandom(),
                  builder: (context, loading, photo) {
                    return Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: photo == null || loading
                          ? CircularProgressIndicator()
                          : Image.network(photo.lowQualityImageUrl),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "This image is fetched every 10 seconds:",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Query<ExamplePhotoModel, ExampleApi>(
                  interval: const Duration(seconds: 10),
                  callBuilder: (ExampleApi api) => api.photos.getRandom(),
                  builder: (context, loading, photo) {
                    return Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: photo == null || loading
                          ? CircularProgressIndicator()
                          : Image.network(photo.lowQualityImageUrl),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _queryKey.currentState.call(),
      ),
    );
  }
}
