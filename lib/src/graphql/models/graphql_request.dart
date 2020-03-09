part of restui;

typedef GraphqlResponseDecoder<T> = T Function(GraphqlResponse);

@experimental
class GraphqlRequest<T> extends ApiRequest {
  final GraphqlApiBase api;
  final String query;
  final String operationName;
  final Map<String, String> variables;
  final GraphqlResponseDecoder<T> decoder;

  /// TODO: support for files
  GraphqlRequest._({
    Map<String, String> headers,
    @required this.api,
    @required this.query,
    this.operationName,
    this.variables,
    String body,
    this.decoder,
    bool multipart,
  }) : super(
          api.uri,
          HttpMethod.post,
          headers: headers,
          body: body,
          multipart: multipart,
        );

  factory GraphqlRequest({
    @required String query,
    Map<String, String> headers,
    GraphqlApiBase api,
    String operationName,
    Map<String, dynamic> variables,
    GraphqlResponseDecoder<T> decoder,
  }) {
    final body = <String, dynamic>{
      "query": query,
      if (operationName != null) "operationName": operationName,
      if (variables != null) "variables": variables,
    };

    // TODO: File sending
    bool isMultipart = false;
    for (final value in variables.values) {
      if (value is File) {
        isMultipart = true;
        break;
      }
    }

    return GraphqlRequest._(
      api: api,
      query: query,
      body: jsonEncode(body),
      decoder: decoder,
      headers: headers,
      multipart: isMultipart,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "query": query,
      if (operationName != null) "operationName": operationName,
      if (variables != null) "variables": variables,
    };
    return map;
  }

  @override
  String toString() => toMap().toString();

  String get key => toString();

  Future<GraphqlResponse> call() => api._call(this);
  Stream<GraphqlResponse> callWithCache() => api._callWithCache(this);
}
