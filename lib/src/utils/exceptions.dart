part of rest_ui;

class ApiException implements Exception {
  final String _message;

  String get message => _message;

  const ApiException(this._message);
}
