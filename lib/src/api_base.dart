part of restui;

/// This class is a simple wrapper around `http` library
/// it's main target is to handle auth headers.
///
/// Override this class in order to
/// add your own methods / requests
///
/// Use call method to hand
abstract class ApiBase extends ApiLink {
  final ApiStorage _storage;
  final Uri _uri;
  Uri get uri => _uri;
  final Map<String, String> _defaultHeaders;
  final ApiLink _link;

  ApiStorage get storage => _storage;

  /// Client is needed for persistent connection
  final http.Client _client;

  /// Call api
  @override
  @protected
  Future<ApiResponse> next(ApiRequest apiRequest) async {
    if (apiRequest.uri == null) {
      throw ApiException("uri cannot be null");
    }

    http.BaseRequest httpRequest = await apiRequest._httpRequest;

    http.StreamedResponse streamedResponse = await _client.send(httpRequest);

    return ApiResponse.fromResponse(
      await http.Response.fromStream(streamedResponse),
    );
  }

  ApiBase({
    @required Uri uri,
    ApiLink link,
    Map<String, String> defaultHeaders,
    List<ApiStore> stores,
  })  : assert(uri != null, "Api widget should be provided with uri argument"),
        _uri = uri,
        _defaultHeaders = defaultHeaders ?? const <String, String>{},
        _link = link,
        _storage = ApiStorage(stores),
        _client = http.Client() {
    /// If link is provided close link chain
    _link?._closeChainWith(this);
  }

  /// Get first link of provided type
  T getFirstLinkOfType<T>() =>
      _link?._firstWhere((ApiLink link) => link is T) as T;

  /// Call rest API by triggering the query lifecycle.
  /// Constructs [ApiRequest] object and invoke [ApiLink]s chain,
  /// then returns data received from it.
  Future<ApiResponse> call({
    @required String endpoint,
    dynamic body = const <String, String>{},
    Map<String, String> headers = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    HttpMethod method = HttpMethod.POST,
    List<FileField> fileFields,
    Encoding encoding,
    bool multipart,
  }) async {
    /// Builds uri object
    Uri uri = Uri(
      scheme: _uri.scheme,
      host: _uri.host,
      path: endpoint,
      queryParameters: queryParameters,
    );

    /// Sets headers
    Map<String, String> requestHeaders = Map<String, String>()
      ..addAll(_defaultHeaders)
      ..addAll(headers);

    final ApiRequest apiRequest = ApiRequest(
      uri,
      method: method,
      headers: requestHeaders,
      body: body,
      fileFields: fileFields,
      encoding: encoding,
      multipart: multipart,
    );

    /// If _link does not exist call [this] link
    /// ([ApiBase] is also an [ApiLink])
    return _link != null ? _link.next(apiRequest) : this.next(apiRequest);
  }

  /// closes http client
  void dispose() {
    _client.close();
  }
}
