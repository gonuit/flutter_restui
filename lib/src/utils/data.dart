part of rest_ui;

enum HttpMethod {
  POST,
  GET,
  DELETE,
  PUT,
  PATCH,
  HEAD,
}

class FileField {
  final File file;
  final String field;
  final String fileName;
  final MediaType contentType;

  const FileField({
    @required this.field,
    @required this.file,
    this.fileName,
    this.contentType,
  });
}
