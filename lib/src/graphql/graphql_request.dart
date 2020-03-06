part of restui;

@experimental
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
