part of restui;

@experimental
class GraphqlResponse {
  final List<GraphqlError> errors;
  final Map data;

  GraphqlResponse.fromJson(dynamic jsonMap)
      : errors = jsonMap["errors"] == null
            ? null
            : List.unmodifiable((jsonMap["errors"] as List).map(
                (error) => GraphqlError.fromJson(error),
              )),
        data = jsonMap["data"];
}
