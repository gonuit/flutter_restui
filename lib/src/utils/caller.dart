part of restui;

/// With this class you are able to make requests every [interval]
class Caller<T> extends ChangeNotifier {
  // final StreamController<T> _controller;
  final AsyncValueGetter<T> _callback;
  Timer _timer;
  bool loading = false;
  T _data;
  T get data => _data;

  /// Streams with values returned by [callback]
  // Stream<T> get stream => _controller.stream;

  /// Returns true whenever [Caller] calls [callback] periodically
  /// (its not stoped)
  bool get isActive => _timer?.isActive ?? false;

  /// Responsible for calling [callback] function every [interval] duration
  ///
  /// When [interval] is not provided.
  /// Caller will has [isActive] equal to `false`
  Caller(AsyncValueGetter<T> callback, {T initialData, Duration interval})
      : _callback = callback,
        _data = initialData {
    if (interval != null)
      start(interval);
    else
      call();
  }

  /// Stops periodic [callback] calls
  void stop() {
    _timer?.cancel();
  }

  /// Starts periodic [callback] calls if stoped
  void start(Duration interval) {
    if (_timer?.isActive == true) return;

    /// call [callback] for the first time
    call();

    /// keep calling [callback] with [interval] duration
    _timer = Timer.periodic(interval, _makeIntervalCall);
  }

  void _makeIntervalCall(Timer timer) async {
    loading = true;
    notifyListeners();
    T response = await _callback();
    loading = false;
    _data = response;
    notifyListeners();
  }

  /// Calls [callback] once and returns its value
  Future<T> call() async {
    T response = await _callback();
    _data = response;
    notifyListeners();
    return response;
  }

  /// Frees up resources
  void dispose() {
    stop();
    super.dispose();
  }
}
