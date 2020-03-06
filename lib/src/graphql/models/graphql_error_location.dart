part of restui;

@experimental
class GraphqlErrorLocation {
  final int line;
  final int column;

  GraphqlErrorLocation.fromJson(dynamic jsonMap)
      : line = jsonMap["line"],
        column = jsonMap["column"];
}
