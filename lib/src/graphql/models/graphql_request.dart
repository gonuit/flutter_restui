part of restui;

typedef GraphqlResponseDecoder<T> = T Function(GraphqlResponse);

@experimental
class GraphqlRequest<T> {
  final GraphqlApiBase api;
  final String query;
  final String operationName;
  final Map<String, String> variables;
  final GraphqlResponseDecoder<T> decoder;

  const GraphqlRequest({
    @required this.api,
    @required this.query,
    this.operationName,
    this.variables,
    this.decoder,
  });

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
