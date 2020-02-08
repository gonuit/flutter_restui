import 'package:example/example_api.dart';
import 'package:example/screens/state_management/photo_store.dart';
import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

class ExampleStateManagementScreen extends StatefulWidget {
  @override
  _ExampleStateManagementScreenState createState() =>
      _ExampleStateManagementScreenState();
}

class _ExampleStateManagementScreenState
    extends State<ExampleStateManagementScreen> {
  final GlobalKey<QueryState<ExampleApi, PhotoStore, String>> _queryKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example Restui state management")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Query<ExampleApi, PhotoStore, String>(
                key: _queryKey,
                instantCall: false,
                updaterBuilder: (BuildContext context, ExampleApi api) =>
                    api.storage.getFirstStoreOfType<PhotoStore>(),
                initialDataBuilder: (BuildContext context, ExampleApi api) =>
                    api.storage.getFirstStoreOfType<PhotoStore>(),
                callBuilder: (
                  BuildContext context,
                  ExampleApi api,
                  String variable,
                ) async {
                  final store = Query.of<ExampleApi>(context)
                      .storage
                      .getFirstStoreOfType<PhotoStore>();

                  if (store.hasPhotoOfId(variable)) {
                    store.removePhotoById(variable);
                  } else {
                    final photo = await api.photos.getById(variable);
                    store.addPhoto(photo);
                  }

                  return store;
                },
                builder: (BuildContext _, bool loading, PhotoStore store) {
                  final photos = store.photos;

                  if (photos.isEmpty) {
                    return Center(child: Text("No Photos"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (BuildContext context, int index) {
                      final photo = photos[index];
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "ID: ${photo.id}\n Author: ${photo.author}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Image.network(
                              photo.downloadUrl,
                              height: 200,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: photos.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).accentColor,
        child: ApiStoreUpdater<ExampleApi, PhotoStore>.builder(
          builder: (context, api, store) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 1; i < 5; i++)
                FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$i"),
                      Icon(
                        store.hasPhotoOfId("${i * 10}")
                            ? Icons.delete
                            : Icons.add,
                      )
                    ],
                  ),
                  onPressed: () => _queryKey.currentState.call("${i * 10}"),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExampleStateManagementScreen())),
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
