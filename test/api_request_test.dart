import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:restui/restui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Creates ApiRequest with minimum data correctly", () {
    final request = ApiRequest(Uri.parse("example.com"), HttpMethod.get);

    expect(
      request.toString(),
      equals(
        "{uri: example.com, body: null, encoding: null, fileFields: [], headers: {}, linkData: {}, method: GET, multipart: null}",
      ),
    );
  });

  test("Creates ApiRequest data correctly", () {
    final request = ApiRequest(
      Uri.parse("example.com"),
      HttpMethod.get,
      body: <String, String>{
        "data": "some_data",
      },
      fileFields: [
        FileField(
          field: "example_photo",
          file: File("path"),
          fileName: "file_name.txt",
        )
      ],
      headers: <String, String>{"header": "header"},
    );

    expect(
      request.toString(),
      equals(
        "{uri: example.com, body: {data: some_data}, encoding: null, fileFields: [{file: File: \'path\', field: example_photo, fileName: file_name.txt, contentType: null}], headers: {header: header}, linkData: {}, method: GET, multipart: null}",
      ),
    );

    expect(request.isMultipart, isTrue);
  });

  test("isMultipart is true when at least one file is provided", () {
    ApiRequest request = ApiRequest(
      Uri.parse("example.com"),
      HttpMethod.get,
      fileFields: null,
    );

    expect(request.isMultipart, isFalse);
    request.fileFields.add(FileField(
      field: "field",
      file: File(
        "path",
      ),
    ));
    expect(request.isMultipart, isTrue);

    request = ApiRequest(
      Uri.parse("example.com"),
      HttpMethod.get,
      fileFields: null,
      multipart: true,
    );
    expect(request.isMultipart, isTrue);
  });

  test("isMultipart is always true when multipart argument is set to true", () {
    ApiRequest request = ApiRequest(
      Uri.parse("example.com"),
      HttpMethod.get,
      multipart: true,
      fileFields: null,
    );

    expect(request.isMultipart, isTrue);
    request.fileFields.add(FileField(
      field: "field",
      file: File(
        "path",
      ),
    ));
    expect(request.isMultipart, isTrue);
  });
}
