part of rest_ui;

@experimental
class DebugLink extends RestLink {
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
  Future<http.Response> next(http.BaseRequest request) async {
    if (request != null && request is http.Request) {
      final req = request;
      if (printRequestBody || printRequestHeaders) {
        print("\n==== REQUEST ====");
        if (printRequestBody) {
          print("body:");
          print(req?.body ?? req?.bodyFields ?? req?.bodyFields);
        }
        if (printRequestHeaders) {
          print("headers:");
          print(req?.headers);
        }
        print("=================\n");
      }
    }
    final response = await super.next(request);
    if (printResponseBody || printResponseHeaders) {
      print("\n==== RESPONSE ====");
      if (response != null) {
        if (printResponseBody) {
          print("body:");
          print(response?.body);
        }
        if (printResponseHeaders) {
          print("headers:");
          print(response?.headers);
        }
      } else {
        print("NULL");
      }
      print("=================\n");
    }
    return response;
  }
}
