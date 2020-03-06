part of restui;

@experimental
class GraphqlApi extends ApiBase {
  static const _graphqlDefaultHeaders = <String, String>{
    "Content-Type": "application/json"
  };

  GraphqlApi({
    @required Uri uri,
    ApiLink link,
    Map<String, String> defaultHeaders,
  }) : super(
          uri: uri,
          link: link,
          defaultHeaders: defaultHeaders != null
              ? (defaultHeaders..addAll(_graphqlDefaultHeaders))
              : Map.from(_graphqlDefaultHeaders),
        );

  Future<GraphqlResponse> _call(GraphqlRequest request) async {
    final response = await call(
      endpoint: uri.path,
      body: jsonEncode(request.toMap()),
      method: HttpMethod.post,
    );
    return GraphqlResponse.fromJson(jsonDecode(response.body));
  }

  Future<GraphqlResponse> query(GraphqlRequest request) => _call(request);
  Future<GraphqlResponse> mutation(GraphqlRequest request) => _call(request);
}
