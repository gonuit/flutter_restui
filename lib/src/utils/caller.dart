part of restui;

/// With this class you are able to make requests every [interval]
class Caller<R> extends ChangeNotifier {
  // final StreamController<T> _controller;
  final AsyncValueGetter<R> _callback;
  final ValueChanged<R> _onComplete;

  final bool _instantCall;
  Timer _timer;
  bool loading = false;
  R _data;
  R get data => _data;

  /// Streams with values returned by [callback]
  // Stream<T> get stream => _controller.stream;

  /// Returns true whenever [Caller] calls [callback] periodically
  /// (its not stoped)
  bool get isActive => _timer?.isActive ?? false;

  /// Responsible for calling [callback] function every [interval] duration
  ///
  /// When [interval] is not provided.
  /// Caller will has [isActive] equal to `false`
  Caller(
    AsyncValueGetter<R> callback, {
    R initialData,
    Duration interval,
    ValueChanged<R> onComplete,
    bool instantCall,
  })  : _callback = callback,
        _onComplete = onComplete,
        _instantCall = instantCall,
        _data = initialData {
    if (interval != null)
      start(interval);
    else if (_instantCall) call();
  }

  /// Stops periodic [callback] calls
  void stop() {
    _timer?.cancel();
  }

  /// Starts periodic [callback] calls if stoped
  void start(Duration interval) {
    if (_timer?.isActive == true) return;

    /// call [callback] for the first time if
    /// [instantCall] is set to true.
    if (_instantCall) call();

    /// keep calling [callback] with [interval] duration
    _timer = Timer.periodic(interval, _makeIntervalCall);
  }

  void _makeIntervalCall(Timer timer) async {
    loading = true;
    notifyListeners();
    R response = await _callback();
    loading = false;

    /// invoke on complete callback
    _onComplete?.call(response);
    _data = response;
    notifyListeners();
  }

  /// Calls [callback] once and returns its value
  Future<R> call() async {
    R response = await _callback();
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
