part of rest_ui;

/// Primitive link class
///
/// Only for in-library operations
abstract class _LinkBase {
  final String debugLabel;
  _LinkBase([this.debugLabel]);
  _LinkBase _nextLink;
  bool _closed = false;

  _LinkBase _chain(_LinkBase nextLink) {
    assert(!_closed, "You can't edit your link after attaching it to ApiBase");
    if (_closed) return null;

    _nextLink = nextLink;
    return nextLink;
  }

  _LinkBase _firstWhere(bool test(_LinkBase link)) {
    _LinkBase lastLink = this;
    do {
      if (test(lastLink)) return lastLink;
      lastLink = lastLink._nextLink;
    } while (lastLink != null);
    return null;
  }

  void _closeChainWith(_LinkBase closingLink) {
    _LinkBase lastLink = this;

    while (lastLink._nextLink != null) {
      /// close current link
      lastLink._closed = true;

      /// get next link
      lastLink = lastLink._nextLink;
    }

    /// chain last link with [closingLink]
    lastLink._chain(closingLink);

    /// close last link
    lastLink._closed = true;
  }

  @protected
  Future<http.Response> _next(http.BaseRequest request) async {
    assert((() {
      if (debugLabel != null) print("RestLink: $debugLabel");
      return true;
    })());

    if (_nextLink == null) return null;
    return await _nextLink?._next(request);
  }
}

/// An abstract class that lets you create your own link
///
/// Each link should extend this method
abstract class RestLink extends _LinkBase {
  final String debugLabel;
  RestLink([this.debugLabel]);

  RestLink chain(RestLink nextLink) => _chain(nextLink);

  Future<http.Response> next(http.BaseRequest request) async => _next(request);
}
