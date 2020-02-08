import 'package:example/example_api.dart';
import 'package:example/screens/state_management/bloc_link.dart';
import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

class ExampleStateManagementScreen extends StatefulWidget {
  @override
  _ExampleStateManagementScreenState createState() =>
      _ExampleStateManagementScreenState();
}

class _ExampleStateManagementScreenState
    extends State<ExampleStateManagementScreen> {
  final GlobalKey<QueryState<ExampleApi, BlocLink, String>> _queryKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Query<ExampleApi, BlocLink, String>(
      key: _queryKey,
      instantCall: false,
      updaterBuilder: (BuildContext context, ExampleApi api) =>
          api.getFirstLinkOfType<BlocLink>(),
      initialDataBuilder: (BuildContext context, ExampleApi api) =>
          api.getFirstLinkOfType<BlocLink>(),
      callBuilder: (
        BuildContext context,
        ExampleApi api,
        String variable,
      ) async {
        final bloc =
            Query.of<ExampleApi>(context).getFirstLinkOfType<BlocLink>();

        if (bloc.hasPhotoOfId(variable)) {
          bloc.removePhotoById(variable);
        } else {
          final photo = await api.photos.getById(variable);
          bloc.addPhoto(photo);
        }

        return bloc;
      },
      builder: (BuildContext _, bool loading, BlocLink bloc) {
        final photos = bloc.photos;

        return Scaffold(
          appBar: AppBar(title: const Text("Example Restui state management")),
          body: photos.isEmpty
              ? Center(child: Text("No Photos"))
              : SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
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
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 1; i < 5; i++)
                  FlatButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("$i"),
                        Icon(
                          bloc.hasPhotoOfId("${i * 10}")
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExampleStateManagementScreen())),
            child: const Icon(Icons.navigate_next),
          ),
        );
      },
    );
  }
}
