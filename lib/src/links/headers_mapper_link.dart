part of rest_ui;

/// This [RestLink] takes headers specified by [headersToMap] argument
/// from response headers and then put to the next request headers.
///
/// It can be used for authorization. For example,we have an `authorization`
/// header that changes after each request and with the next query we
/// must send it back in headers. This [RestLink] will take it from the
/// response, save and set as a next request header.
class HeadersMapperLink extends RestLink {
  final Map<String, String> _headers;
  final List<String> _headersToMap;
  final bool _debug;

  /// Construct [RestLink] that takes headers specified by [headersToMap]
  /// argument from response headers and then put to the next request headers.
  HeadersMapperLink(List<String> headersTopMap, {bool debug = false})
      : _headersToMap = headersTopMap,
        _debug = debug,
        _headers = {};

  /// Get currently saved headers
  Map<String, String> get headers => Map.unmodifiable(_headers);

  /// Saves headers for later use
  void setHeaders(Map<String, String> headers) {
    for (final headerToMap in _headersToMap) {
      final value = headers[headerToMap];
      if (value == null) continue;
      _headers[headerToMap] = value;
    }

    /// Print new headers
    assert((() {
      if (_debug) print(jsonEncode(_headers));
      return true;
    })());
  }

  /// Removes all saved headers
  void clear() => _headers.clear();

  @override
  Future<http.Response> next(http.BaseRequest request) async {
    request.headers.addAll(_headers);
    http.Response response = await super.next(request);
    setHeaders(response.headers);
    return response;
  }

  @override
  String toString() => jsonEncode(_headers);
}
