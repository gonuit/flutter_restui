import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

import 'example_photo_model.dart';
import 'example_api.dart';

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final GlobalKey<QueryState<ExamplePhotoModel, ExampleApi>> _queryKey =
      GlobalKey();

  final initialPhoto = const ExamplePhotoModel(
    author: "Oleg Chursin",
    id: "43",
    width: 1280,
    height: 831,
    url: "https://unsplash.com/photos/IoCWq07GaG4",
    downloadUrl: "https://picsum.photos/id/43/200/200",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restui example"),
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
                  /// Assign [GlobalKey<QueryState<ExamplePhotoModel, ExampleApi>>] to get access to [call] method.
                  /// Then you can e.g. assign this method to button and invoke call every button tap
                  ///
                  /// It is important to set [instantCall] to false if you do not want to call api right before first
                  /// widget [build].
                  key: _queryKey,
                  initialData: initialPhoto,
                  instantCall: false,
                  callBuilder: (BuildContext context, ExampleApi api) =>
                      api.photos.getRandom(),
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
                  /// Because [interval] is provided, [Query] will invoke
                  /// [callBuilder] every duration of [interval].
                  interval: const Duration(seconds: 10),
                  callBuilder: (BuildContext context, ExampleApi api) =>
                      api.photos.getRandom(),
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

        /// Calls refresh on tap
        onPressed: () => _queryKey.currentState.call(),
      ),
    );
  }
}
