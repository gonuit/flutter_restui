part of restui;

@experimental
class GraphqlResponse extends ApiResponse {
  final List<GraphqlError> errors;
  final Map data;
  final GraphqlResponseSource source;

  GraphqlResponse({
    @required this.errors,
    @required this.data,
    @required this.source,
    @required http.Request request,
    @required http.Response response,
  }) : super.fromHttp(request, response);

  factory GraphqlResponse.fromHttp(
    http.Request request,
    http.Response response, {
    @required GraphqlResponseSource source,
  }) {
    final jsonMap = jsonDecode(response.body);
    return GraphqlResponse(
      errors: jsonMap["errors"] == null
          ? null
          : List.unmodifiable((jsonMap["errors"] as List).map(
              (error) => GraphqlError.fromJson(error),
            )),
      data: jsonMap["data"],
      source: source,
      request: request,
      response: response,
    );
  }

  GraphqlResponse copyWith({
    List<GraphqlError> errors,
    Map data,
    GraphqlResponseSource source,
  }) =>
      GraphqlResponse(
        errors: errors ?? this.errors,
        data: data ?? this.data,
        source: source ?? this.source,

        // unchanged
        request: this.request,
        response: this,
      );

  bool get hasErrors => errors != null && errors.isNotEmpty;
}
