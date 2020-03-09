part of restui;

class HttpLink with ApiLink {
  /// Client is needed for persistent connection
  final http.Client _client;
  http.Client get client => _client;

  HttpLink([http.Client client]) : _client = client ?? http.Client();

  @override
  @protected
  Future<ApiResponse> next(ApiRequest apiRequest) async {
    http.BaseRequest httpRequest = await apiRequest.buildHttpRequest();

    http.StreamedResponse streamedResponse = await _client.send(
      httpRequest,
    );

    http.Response httpResponse = await http.Response.fromStream(
      streamedResponse,
    );

    return ApiResponse.fromHttp(httpRequest, httpResponse);
  }

  @override
  void dispose() {
    super.dispose();
    _client.close();
  }
}

/// This class is a simple wrapper around `http` library
/// it's main target is to handle auth headers.
///
/// Override this class in order to
/// add your own methods / requests
///
/// Use call method to hand
abstract class ApiBase {
  final Uri _uri;
  Uri get uri => _uri;
  final Map<String, String> _defaultHeaders;
  final ApiLink _link;

  ApiBase({
    @required Uri uri,
    ApiLink link,
    Map<String, String> defaultHeaders,
  })  : assert(uri != null, "Api widget should be provided with uri argument"),
        _uri = uri,
        _defaultHeaders = defaultHeaders ?? const <String, String>{},
        _link = link._firstLink ?? link ?? HttpLink() {
    assert(
      _link._firstWhere((apiLink) => (apiLink is HttpLink)) != null,
      "ApiLinks chain should contain HttpLink",
    );

    /// Close link chain
    _link._closeChain();
  }

  /// Get first link of provided type
  T getFirstLinkOfType<T>() =>
      _link?._firstWhere((ApiLink link) => link is T) as T;

  /// Builds secific [Uri] object
  Uri getUrl(String endpoint, Map<String, String> queryParameters) => Uri(
        scheme: _uri.scheme,
        host: _uri.host,
        path: endpoint,
        queryParameters: queryParameters,
      );

  /// Returns default API headers with optional additional headers passed as an argument
  Map<String, String> getHeaders([Map<String, String> additionalHeaders]) =>
      (Map<String, String>.from(_defaultHeaders)
        ..addAll(additionalHeaders ?? {}));

  /// Make API request by triggering [ApiLink]s [next] methods
  @protected
  Future<ApiResponse> makeRequest(ApiRequest request) {
    return _link.next(request);
  }

  /// Call rest API by triggering the query lifecycle.
  /// Constructs [ApiRequest] object and invoke [ApiLink]s chain,
  /// then returns data received from it.
  Future<ApiResponse> call({
    @required String endpoint,
    dynamic body,
    Map<String, String> headers = const <String, String>{},
    Map<String, String> queryParameters,
    HttpMethod method = HttpMethod.post,
    List<FileField> fileFields,
    Encoding encoding,
    bool multipart,
  }) async {
    /// Builds secific url object
    Uri uri = getUrl(endpoint, queryParameters);

    /// Builds request headers
    Map<String, String> requestHeaders = getHeaders(headers);

    final ApiRequest apiRequest = ApiRequest(
      uri,
      method,
      headers: requestHeaders,
      body: body,
      fileFields: fileFields,
      encoding: encoding,
      multipart: multipart,
    );

    return makeRequest(apiRequest);
  }

  /// closes http client
  void dispose() => _link._forEach((link) => link.dispose());
}

class RestApiBase extends ApiBase {}
