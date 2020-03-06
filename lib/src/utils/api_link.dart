part of restui;

/// ApiLink that is mixed witch ChangeNotifier
abstract class NotifierApiLink extends ApiLink with ChangeNotifier {}

/// An abstract class that lets you create your own link
///
/// Each link should extend this method
abstract class ApiLink {
  ApiLink _nextLink;
  bool _closed = false;

  ApiLink _firstWhere(bool test(ApiLink link)) {
    ApiLink lastLink = this;
    do {
      if (test(lastLink)) return lastLink;
      lastLink = lastLink._nextLink;
    } while (lastLink != null);
    return null;
  }

  void _closeChainWith(ApiLink closingLink) {
    ApiLink lastLink = this;

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

  @nonVirtual
  ApiLink chain(ApiLink nextLink) {
    assert(!_closed, "You can't modify your links chain after attaching it to ApiBase");
    if (_closed) return null;

    _nextLink = nextLink;
    return nextLink;
  }

  @protected
  Future<ApiResponse> next(ApiRequest request) async =>
      _nextLink?.next(request);
}
