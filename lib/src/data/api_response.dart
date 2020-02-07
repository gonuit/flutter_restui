part of restui;

class ApiResponse {
  /// Here you can assing your data that will be passed to the next link
  final Map<String, dynamic> linkData = {};

  /// Response returned from http client call
  final http.Response _httpResponse;

  String get body => _httpResponse.body;
  Uint8List get bodyBytes => _httpResponse.bodyBytes;
  int get contentLength => _httpResponse.contentLength;
  Map<String, String> get headers => _httpResponse.headers;
  bool get isRedirect => _httpResponse.isRedirect;
  bool get persistentConnection => _httpResponse.persistentConnection;
  String get reasonPhrase => _httpResponse.reasonPhrase;
  http.BaseRequest get request => _httpResponse.request;
  int get statusCode => _httpResponse.statusCode;

  ApiResponse.fromResponse(this._httpResponse);
}
