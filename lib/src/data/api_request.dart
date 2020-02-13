part of restui;

class ApiRequest {
  /// Here you can assing your data that will be passed to the next link
  Uri uri;
  HttpMethod method;
  Encoding encoding;
  bool multipart;
  dynamic body;
  final Map<String, dynamic> linkData = {};
  final List<FileField> fileFields = [];
  final Map<String, String> headers = {};

  ApiRequest(
    this.uri, {
    @required this.method,
    @required Map<String, String> headers,
    @required List<FileField> fileFields,
    @required this.body,
    @required this.encoding,
    @required this.multipart,
  }) {
    if (fileFields != null) this.fileFields.addAll(fileFields);
    if (headers != null) this.headers.addAll(headers);
  }

  bool get isMultipart => multipart == true || fileFields.isNotEmpty;

  Future<http.BaseRequest> get _httpRequest =>
      isMultipart ? _makeMultipartHttpRequest() : _makeHttpRequest();

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

  /// Make [MultipartRequest] without files
  Future<http.BaseRequest> _makeMultipartHttpRequest() async {
    final request = http.MultipartRequest(_getHttpMethodString(method), uri)
      ..headers.addAll(headers);

    /// Assign body if it is map
    if (body != null) {
      if (body is Map)
        request.fields.addAll(body.cast<String, String>());
      else
        throw ArgumentError(
          'Invalid request body "$body".\n'
          'Multipart request body should be map',
        );
    }

    /// Assign files to [MultipartRequest]
    for (final fileField in fileFields)
      request.files.add(await fileField.toMultipartFile());

    return request;
  }

  /// Make [Request] without files
  Future<http.BaseRequest> _makeHttpRequest() async {
    final request = http.Request(_getHttpMethodString(method), uri);

    if (headers != null) request.headers.addAll(headers);
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
    return request;
  }
}
