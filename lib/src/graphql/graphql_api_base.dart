part of restui;

@experimental
abstract class GraphqlCache {
  void clear();

  void remove(String key);

  FutureOr<GraphqlResponse> get(String key);

  void set(String key, GraphqlResponse response);
}

@experimental
class GraphqlInMemoryCache extends GraphqlCache {
  final Map<String, GraphqlResponse> _cache = {};

  @override
  GraphqlResponse get(String key) => _cache[key];

  @override
  void set(String key, GraphqlResponse response) {
    _cache[key] = response;
  }

  @override
  void remove(String key) {
    _cache.remove(key);
  }

  @override
  void clear() {
    _cache.clear();
  }
}

@experimental
enum GraphqlResponseSource {
  cache,
  network,
}

@experimental
enum GraphqlFetchPolicy {
  cache,
  network,
  cacheAndNetwork,
}

class GraphqlLink extends HttpLink {
  GraphqlLink([http.Client client]) : super(client);

  /// Makes request to API
  @override
  @protected
  Future<ApiResponse> next(ApiRequest request) async {
    final response = await super.next(request);

    return GraphqlResponse.fromHttp(
      response.request,
      response,
      source: GraphqlResponseSource.network,
    );
  }

  @override
  void dispose() {
    super.dispose();
    client.close();
  }
}

@experimental
class GraphqlApiBase extends ApiBase {
  static const _graphqlDefaultHeaders = <String, String>{
    "Content-Type": "application/json"
  };

  GraphqlCache _cache;

  GraphqlApiBase({
    @required Uri uri,
    GraphqlCache cache,
    ApiLink link,
    Map<String, String> defaultHeaders,
  })  : _cache = cache ?? GraphqlInMemoryCache(),
        super(
          uri: uri,
          link: link ?? GraphqlLink(),
          defaultHeaders: defaultHeaders != null
              ? (defaultHeaders..addAll(_graphqlDefaultHeaders))
              : Map.from(_graphqlDefaultHeaders),
        ) {
    assert(
      _link._firstWhere((apiLink) => (apiLink is GraphqlLink)) != null,
      "ApiLinks chain should contain GraphqlLink",
    );
  }

  Future<GraphqlResponse> _call(GraphqlRequest request) async {
    final response = await call(
      endpoint: uri.path,
      body: jsonEncode(request.toMap()),
      method: HttpMethod.post,
    );
    assert(response is GraphqlResponse,
        "Response should be of type GraphqlResponse");
    return response as GraphqlResponse;
  }

  /// TODO: add fetch policy
  Stream<GraphqlResponse> _callWithCache(GraphqlRequest request) async* {
    FutureOr<GraphqlResponse> cachedResponse = _cache.get(request.key);
    if (cachedResponse != null) {
      if (cachedResponse is Future) {
        cachedResponse = await cachedResponse;
      }
      yield cachedResponse as GraphqlResponse;
    }

    final networkResponse = await _call(request);

    if (!networkResponse.hasErrors) {
      _cache.set(
        request.key,

        /// cached response should have source set to cache
        networkResponse.copyWith(source: GraphqlResponseSource.cache),
      );
    }

    yield networkResponse;
  }

  Future<GraphqlResponse> query(GraphqlRequest request) => _call(request);
  Future<GraphqlResponse> mutation(GraphqlRequest request) => _call(request);
}
