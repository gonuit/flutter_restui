part of restui;

class ApiResponse {
  /// Here you can assing your data that will be passed to the next link
  final Map<String, dynamic> linkData = {};

  /// Response returned from http client call
  final http.Response httpResponse;
  ApiResponse.fromResponse(this.httpResponse);
}
