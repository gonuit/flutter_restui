part of restui;

@experimental
class GraphqlResponse {
  final List<GraphqlError> errors;
  final Map data;
  final GraphqlResponseSource source;

  GraphqlResponse({
    @required this.errors,
    @required this.data,
    @required this.source,
  }) : assert(source != null, "from cache cannot be null");

  factory GraphqlResponse.fromJson(
    dynamic jsonMap, {
    @required GraphqlResponseSource source,
  }) =>
      GraphqlResponse(
        source: source,
        errors: jsonMap["errors"] == null
            ? null
            : List.unmodifiable((jsonMap["errors"] as List).map(
                (error) => GraphqlError.fromJson(error),
              )),
        data: jsonMap["data"],
      );

  GraphqlResponse copyWith({
    List<GraphqlError> errors,
    Map data,
    GraphqlResponseSource source,
  }) =>
      GraphqlResponse(
        errors: errors ?? this.errors,
        data: data ?? this.data,
        source: source ?? this.source,
      );

  bool get hasErrors => errors != null && errors.isNotEmpty;
}
