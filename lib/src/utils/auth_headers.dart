part of rest_ui;

// TODO: add afterware

/// Keeps headers needed for authorization
class AuthHeaders {
  final Map<String, String> _headers;

  AuthHeaders({
    String uid = "",
    String accessToken = "",
    String client = "",
  }) : _headers = {
          'uid': uid,
          'access-token': accessToken,
          'client': client,
        };

  Map<String, String> get headers => _headers;
  String get uid => _headers["uid"];
  String get accessToken => _headers["access-token"];
  String get client => _headers["client"];

  void set uid(String value) {
    if (value == null) return;
    _headers["uid"] = value;
  }

  void set accessToken(String value) {
    if (value == null) return;
    _headers["access-token"] = value;
  }

  void set client(String value) {
    if (value == null) return;
    _headers["client"] = value;
  }

  void set headers(Map<String, String> headers) {
    /// Only debug print
    assert((() {
      print(jsonEncode(this.headers));
      return true;
    })());

    client = headers["client"];
    uid = headers["uid"];
    accessToken = headers["access-token"];
  }

  void clear() {
    uid = "";
    client = "";
    accessToken = "";
  }

  AuthHeaders copyWith({
    String uid,
    String accessToken,
    String client,
  }) =>
      AuthHeaders(
        uid: uid = uid ?? this.uid,
        accessToken: accessToken ?? this.accessToken,
        client: client = client ?? this.client,
      );

  @override
  String toString() => _headers.toString();
}

class RestQuery {
  final Map<String, String> headers;
  final dynamic body;

  RestQuery({
    @required this.headers,
    @required this.body,
  });
}

abstract class RestLink<I, O> {
  final String debugLabel;
  RestLink([this.debugLabel]);
  RestLink _nextLink;
  RestLink _prevLink;

  RestLink chain<O>(RestLink<I, O> nextLink) {
    _nextLink = nextLink;
    return nextLink;
  }

  O next(I dataIn) {
    assert((() {
      print(debugLabel);
      return true;
    })());

    if (_nextLink == null && dataIn is O) return dataIn;
    return _nextLink?.next(dataIn);
  }
}

class AuthLink extends RestLink<int, int> {
  AuthLink(String a) : super(a);

  @override
  int next(int dataIn) {
    return super.next(dataIn);
  }
}

class Test {
  void test() {
    final link = AuthLink("1")
      ..chain<int>(AuthLink("2"))
          .chain<int>(AuthLink("3"))
          .chain<int>(AuthLink("4"))
          .chain<int>(AuthLink("5"));

    final response = link.next(1);
    print("response: $response");
  }
}
