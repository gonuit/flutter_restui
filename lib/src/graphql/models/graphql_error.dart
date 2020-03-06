part of restui;

@experimental
class GraphqlError {
  final String message;
  final List<dynamic> path;
  final List<GraphqlErrorLocation> locations;
  final Map extensions;

  GraphqlError.fromJson(dynamic jsonMap)
      : message = jsonMap["message"],
        path = (jsonMap["path"] as List),
        extensions = jsonMap["extensions"] == null
            ? null
            : Map.unmodifiable(jsonMap["extensions"]),
        locations = jsonMap["locations"] == null
            ? null
            : List.unmodifiable(
                (jsonMap["locations"] as List).map(
                  (location) => GraphqlErrorLocation.fromJson(location),
                ),
              );
}
