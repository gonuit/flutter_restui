part of restui;

/// Class that manages [callback] function invokation.
class Caller<R> extends ChangeNotifier {
  final AsyncValueGetter<R> _callback;
  final ValueChanged<R> _onComplete;
  final ValueChanged<Exception> _onError;
  final bool _instantCall;

  /// Caller state

  R _data;
  Timer _timer;
  int _ongoingRequestsCount = 0;

  /// Keeps information whether [callback] is ongoing.
  ///
  /// It is possible that [callback] was called more than once.If so,[loading]
  /// will return `true` as long as there is at least one ongoing [callback] call.
  bool get loading => _ongoingRequestsCount > 0;

  /// Last data returned from [callback] function
  R get data => _data;

  /// Whether [Caller] is invoking [callback] function every [interval] duration.
  bool get isPeriodic => _timer?.isActive == true;

  /// Returns true whenever [Caller] calls [callback] periodically
  /// (its not stoped)
  bool get isActive => _timer?.isActive ?? false;

  /// Responsible for calling [callback] function every [interval] duration
  ///
  /// When [interval] is not provided.
  /// Caller will has [isActive] equal to `false`
  Caller(
    /// A function that will be controlled by the [Caller] class.
    ///
    /// Value returned from [callback] will be stored in [data] object property
    AsyncValueGetter<R> callback, {

    /// Data that will be assigned to [Caller] [data] property
    /// from its' constructor
    R initialData,

    /// Providing an  interval will cause calling [callback]
    /// every [interval] duration
    Duration interval,

    /// If [callback] function will throw an [Exception] it will be
    /// catched and provided with [onError] callback if it's declared.
    ValueChanged<Exception> onError,

    /// [onComplete] is called only when [callback] function returned succesfuly
    /// without throwing an [Exception].
    ///
    /// Throwing an [Exception] from [callback] method will cause
    /// [onError] function invocation instead.
    ValueChanged<R> onComplete,

    /// Whether to invoke [callback] immediately from [Caller] constructor
    bool instantCall,
  })  : _callback = callback,
        _onComplete = onComplete,
        _onError = onError,
        _instantCall = instantCall,
        _data = initialData {
    if (interval != null)
      start(interval);
    else if (_instantCall) call();
  }

  /// Stops periodic [callback] calls
  ///
  /// Calling it when [isPeriodic] property equals `false`
  /// will take no effect
  void stop() {
    _timer?.cancel();
  }

  /// Starts periodic [callback] calls if stoped.
  void start(Duration interval) {
    assert(
        interval != null && !interval.isNegative,
        "interval argument should be provided"
        "and must be a non-negative value");

    if (_timer?.isActive == true) return;

    /// call [callback] for the first time if
    /// [instantCall] is set to true.
    if (_instantCall) call();

    /// keep calling [callback] with [interval] duration
    _timer = Timer.periodic(interval, _makeIntervalCall);
  }

  void _makeIntervalCall(Timer timer) async {
    /// Prevents multiple calls from one caller
    _ongoingRequestsCount++;
    notifyListeners();

    R response;
    try {
      response = await _callback();
    } on Exception catch (err) {
      /// invoke on error callback
      _onError?.call(err);

      /// Prevent [onComplete] callback invocation
      return;
    } finally {
      _ongoingRequestsCount--;
    }

    /// invoke on complete callback
    _onComplete?.call(response);

    /// Assign new data
    _data = response;

    /// Update listeners
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
