import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:restui/restui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ApiResponse response;
  Request request = Request(
    "POST",
    Uri.parse("example.com"),
  );
  test("Constructs ApiResponse from http response correctly", () {
    response = ApiResponse.fromHttpResponse(Response(
      "body",
      200,
      headers: const <String, String>{"header": "header"},
      isRedirect: false,
      persistentConnection: true,
      reasonPhrase: "reasonPhrase",
      request: request,
    ));

    expect(
      response,
      isInstanceOf<ApiResponse>(),
    );
  });

  test("ApiResponse returns proper data", () {
    expect(response.body, equals("body"));
    expect(response.bodyBytes, equals([98, 111, 100, 121]));
    expect(response.contentLength, equals(4));
    expect(response.headers, equals({'header': 'header'}));
    expect(response.isRedirect, isFalse);
    expect(response.reasonPhrase, "reasonPhrase");
    expect(response.request, equals(request));
    expect(response.statusCode, equals(200));
  });

  test("linkData works correctly", () {
    expect(response.linkData, const {});
    response.linkData.addAll({"a": "a"});
    expect(response.linkData, equals({"a": "a"}));
  });
}
