part of restui;

enum HttpMethod {
  post,
  get,
  delete,
  put,
  patch,
  head,
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
