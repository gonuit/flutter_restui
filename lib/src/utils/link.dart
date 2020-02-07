part of rest_ui;

/// An abstract class that lets you create your own link
///
/// Each link should extend this method
abstract class RestLink {
  RestLink _nextLink;
  bool _closed = false;

  RestLink _firstWhere(bool test(RestLink link)) {
    RestLink lastLink = this;
    do {
      if (test(lastLink)) return lastLink;
      lastLink = lastLink._nextLink;
    } while (lastLink != null);
    return null;
  }

  void _closeChainWith(RestLink closingLink) {
    RestLink lastLink = this;

    while (lastLink._nextLink != null) {
      /// close current link
      lastLink._closed = true;

      /// get next link
      lastLink = lastLink._nextLink;
    }

    /// chain last link with [closingLink]
    lastLink.chain(closingLink);

    /// close last link
    lastLink._closed = true;
  }

  RestLink chain(RestLink nextLink) {
    assert(!_closed, "You can't edit your link after attaching it to ApiBase");
    if (_closed) return null;

    _nextLink = nextLink;
    return nextLink;
  }

  @protected
  Future<http.Response> next(http.BaseRequest request) async =>
      _nextLink?.next(request);
}
