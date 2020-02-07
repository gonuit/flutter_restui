part of restui;

@experimental
class DebugLink extends ApiLink {
  bool printResponseBody;
  bool printResponseHeaders;
  bool printRequestBody;
  bool printRequestHeaders;
  DebugLink({
    this.printRequestBody = false,
    this.printRequestHeaders = false,
    this.printResponseBody = false,
    this.printResponseHeaders = false,
  }) : assert(printRequestBody != null &&
            printRequestBody != null &&
            printResponseBody != null &&
            printResponseHeaders != null);

  @override
  Future<ApiResponse> next(ApiRequest request) async {
    if (printRequestBody || printRequestHeaders) {
      print("\n==== REQUEST ====");
      if (printRequestBody) {
        print("body:");
        print(request?.body);
      }
      if (printRequestHeaders) {
        print("headers:");
        print(request?.headers);
      }
      print("=================\n");
    }
    final response = await super.next(request);
    if (printResponseBody || printResponseHeaders) {
      print("\n==== RESPONSE ====");
      if (response?.httpResponse != null) {
        if (printResponseBody) {
          print("body:");
          print(response.httpResponse.body);
        }
        if (printResponseHeaders) {
          print("headers:");
          print(response.httpResponse.headers);
        }
      } else {
        print("NULL");
      }
      print("=================\n");
    }
    return response;
  }
}
