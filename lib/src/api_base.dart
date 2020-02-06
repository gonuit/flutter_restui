part of rest_ui;

/// This class is a simple wrapper around `http` library
/// it's main target is to handle auth headers.
///
/// Override this class in order to
/// add your own methods / requests
///
/// Use call method to hand
abstract class ApiBase {
  final Uri _uri;
  final AuthHeaders _authHeaders;
  final Map<String, String> _defaultHeaders;

  /// Client is needed for persistent connection
  final http.Client _client;

  static String _getHttpMethodString(HttpMethod method) {
    switch (method) {
      case HttpMethod.GET:
        return "GET";
      case HttpMethod.POST:
        return "POST";
      case HttpMethod.DELETE:
        return "DELETE";
      case HttpMethod.PATCH:
        return "PATCH";
      case HttpMethod.PUT:
        return "PUT";
      default:
        throw ApiException("The HTTP method provided was not recognized");
    }
  }

  ApiBase({
    @required Uri uri,
    Map<String, String> defaultHeaders,
  })  : assert(uri != null, "Api widget should be provided with uri argument"),
        _uri = uri,
        _defaultHeaders = defaultHeaders ?? const <String, String>{},
        _authHeaders = AuthHeaders(),
        _client = http.Client();

  /// Make [MultipartRequest] without files
  Future<http.Response> _makeMultipartRequest(
    Uri uri, {
    @required HttpMethod method,
    @required Map<String, String> requestHeaders,
    @required dynamic body,
    @required List<FileField> fileFields,
    Encoding encoding,
  }) async {
    final request = http.MultipartRequest(_getHttpMethodString(method), uri)
      ..headers.addAll(requestHeaders);

    /// Assign body if it is map
    if (body != null) {
      if (body is Map)
        request.fields.addAll(body.cast<String, String>());
      else
        throw ArgumentError('Invalid request body "$body".');
    }

    /// Assign files to [MultipartRequest]
    for (final fileField in fileFields) {
      final multipartFile = await http.MultipartFile.fromPath(
        fileField.field,
        fileField.file.path,
        contentType: fileField.contentType,
        filename: fileField.fileName,
      );
      request.files.add(multipartFile);
    }

    http.StreamedResponse streamedResponse = await _client.send(request);
    return http.Response.fromStream(streamedResponse);
  }

  /// Make [Request] without files
  Future<http.Response> _makeRequest(
    Uri uri, {
    @required HttpMethod method,
    @required Map<String, String> requestHeaders,
    @required dynamic body,
    @required List<FileField> fileFields,
    Encoding encoding,
  }) async {
    final request = http.Request(_getHttpMethodString(method), uri);

    if (requestHeaders != null) request.headers.addAll(requestHeaders);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String)
        request.body = body;
      else if (body is List)
        request.bodyBytes = body.cast<int>();
      else if (body is Map)
        request.bodyFields = body.cast<String, String>();
      else
        throw ArgumentError('Invalid request body "$body".');
    }
    http.StreamedResponse streamedResponse = await _client.send(request);
    return http.Response.fromStream(streamedResponse);
  }

  /// Call rest api
  /// Automaticly handle and update [AuthHeaders]
  Future<http.Response> call({
    @required String endpoint,
    Map<String, dynamic> body = const <String, String>{},
    Map<String, String> headers = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    HttpMethod method = HttpMethod.POST,
    List<FileField> fileFields,
  }) async {
    /// Builds uri object
    Uri uri = Uri(
      scheme: _uri.scheme,
      host: _uri.host,
      path: endpoint,
      queryParameters: queryParameters,
    );

    /// Sets headers
    Map<String, String> requestHeaders = {};
    requestHeaders
      ..addAll(_defaultHeaders)
      ..addAll(_authHeaders.headers)
      ..addAll(headers);

    final hasFiles = fileFields != null && fileFields.isNotEmpty;

    http.Response response = await (hasFiles
        ? _makeMultipartRequest(
            uri,
            fileFields: fileFields,
            method: method,
            body: body,
            requestHeaders: requestHeaders,
          )
        : _makeRequest(
            uri,
            fileFields: fileFields,
            method: method,
            body: body,
            requestHeaders: requestHeaders,
          ));

    /// Sets headers
    _authHeaders.headers = response.headers;
    return response;
  }

  /// closes http client
  void dispose() {
    _client.close();
  }
}
