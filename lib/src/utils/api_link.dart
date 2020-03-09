part of restui;

/// ApiLink that is mixed witch ChangeNotifier
abstract class NotifierApiLink extends ApiLink with ChangeNotifier {}

/// An abstract class that lets you create your own link
///
/// Each link should extend this method
abstract class ApiLink {
  /// [ApiLink]s keeps reference to the first [ApiLink] in chain to simplify chaining
  ApiLink _firstLink;
  ApiLink _nextLink;
  bool _disposed = false;
  bool get disposed => false;
  bool _closed = false;
  bool get closed => _closed;
  bool get chained => _nextLink != null;

  /// calls [callback] for every link in chain
  void _forEach(ValueChanged<ApiLink> callback) {
    ApiLink lastLink = _firstLink ?? this;
    do {
      callback(lastLink);
      lastLink = lastLink._nextLink;
    } while (lastLink != null);
  }

  ApiLink _firstWhere(bool test(ApiLink link)) {
    ApiLink lastLink = _firstLink ?? this;
    do {
      if (test(lastLink)) return lastLink;
      lastLink = lastLink._nextLink;
    } while (lastLink != null);
    return null;
  }

  /// Closes all links
  void _closeChain() {
    /// If _firstLink is not set, set it to [this] and close link chain
    _firstLink ??= this;
    _forEach((ApiLink link) {
      link._closed = true;
    });
  }

  @nonVirtual
  ApiLink chain(ApiLink nextLink) {
    assert(
      nextLink != null,
      "nextLink cannot be null",
    );

    assert(
      !closed || !nextLink.closed,
      "You cannot modify your links chain after attaching it to ApiBase",
    );
    assert(
      !disposed && !nextLink.disposed,
      "You cannot chain disposed links",
    );

    assert(
      !(this is HttpLink),
      "Adding link after http link will take no effect",
    );

    if (nextLink == null ||
        this is HttpLink ||
        closed ||
        disposed ||
        nextLink.disposed == true) return null;

    if (_firstLink == null) {
      _firstLink = this;
    }

    nextLink._firstLink = _firstLink;

    _nextLink = nextLink;
    return nextLink;
  }

  @protected
  Future<ApiResponse> next(ApiRequest request) {
    return _nextLink?.next(request);
  }

  /// Called when API object has been disposed
  ///
  /// Here you can frees up your resources
  @mustCallSuper
  void dispose() {
    assert(_disposed == false, "ApiLink cannot be disposed more than once");
    _disposed = true;
  }

  @override
  String toString() => "ApiLink: ${this.runtimeType}";
}
