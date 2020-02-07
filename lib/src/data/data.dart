part of restui;

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

  /// Convert FileField to multipart file
  Future<http.MultipartFile> toMultipartFile() => http.MultipartFile.fromPath(
        field,
        file.path,
        contentType: contentType,
        filename: fileName,
      );
}
