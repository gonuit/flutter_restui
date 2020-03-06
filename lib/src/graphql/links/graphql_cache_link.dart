part of restui;

@experimental
class GraphqlCacheLink extends ApiLink {
  final Map<String, dynamic> _cache = <String, dynamic>{};

  @override
  Future<ApiResponse> next(ApiRequest request) async {
    final body = request.body.toString();

    final result = _cache[body];
    if (result != null) return result;

    ApiResponse response = await super.next(request);
    _cache[body] = response;
    return response;
  }
}
