part of restui;

class GraphqlRequest {
  final String query;
  final String operationName;
  final Map<String, String> variables;

  GraphqlRequest({
    @required this.query,
    this.operationName,
    this.variables,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "query": query,
      if (operationName != null) "operationName": operationName,
      if (variables != null) "variables": variables,
    };
    return map;
  }
}

class GraphqlErrorLocation {
  final int line;
  final int column;

  GraphqlErrorLocation.fromJson(dynamic jsonMap)
      : line = jsonMap["line"],
        column = jsonMap["column"];
}

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
            : List.unmodifiable((jsonMap["locations"] as List)
                .map((location) => GraphqlErrorLocation.fromJson(location)));
}

class GraphqlResponse {
  final List<GraphqlError> errors;
  final Map data;

  GraphqlResponse.fromJson(dynamic jsonMap)
      : errors = jsonMap["errors"] == null
            ? null
            : List.unmodifiable((jsonMap["errors"] as List)
                .map((error) => GraphqlError.fromJson(error))),
        data = jsonMap["data"];
}

class GraphqlApi extends ApiBase {
  static const _graphqlDefaultHeaders = <String, String>{
    "Content-Type": "application/json"
  };

  GraphqlApi({
    @required Uri uri,
    ApiLink link,
    Map<String, String> defaultHeaders,
    List<ApiStore> stores,
  }) : super(
          uri: uri,
          link: link,
          defaultHeaders: defaultHeaders != null
              ? (defaultHeaders..addAll(_graphqlDefaultHeaders))
              : Map.from(_graphqlDefaultHeaders),
          stores: stores,
        );

  Future<GraphqlResponse> _call(GraphqlRequest request) async {
    final response = await call(
      endpoint: uri.path,
      body: jsonEncode(request.toMap()),
      method: HttpMethod.POST,
    );
    return GraphqlResponse.fromJson(jsonDecode(response.body));
  }

  Future<GraphqlResponse> query(GraphqlRequest request) => _call(request);
  Future<GraphqlResponse> mutation(GraphqlRequest request) => _call(request);
}
