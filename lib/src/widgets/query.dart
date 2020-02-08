part of restui;

typedef QueryWidgetBuilder<T> = Widget Function(
  BuildContext context,
  bool loading,
  T response,
);
typedef QueryCallBuilder<R, A, V> = Future<R> Function(
    BuildContext context, A api, V variable);

typedef QueryInitialDataBuilder<R, A> = R Function(BuildContext context, A api);

typedef UpdaterBuilder<A> = Listenable Function(BuildContext context, A api);

typedef QueryOnComplete<V> = void Function(BuildContext context, V value);

/// Widget responsible for refreshing part of the tree with updated data
///
/// If you want to have full controll when [callBuilder] will be called.
/// Provide this widget with a key argument of type `GlobalKey<QueryState<R,A>>`.
/// Then you can trigger the query lifecycle by `call` method invocation on
/// [QueryState] object. It could be useful e.g. when you want to upload
/// a file and you want to do this only once right after its selection.
class Query<A extends ApiBase, R, V> extends StatefulWidget {
  final QueryWidgetBuilder<R> _builder;
  final Duration _interval;
  final QueryCallBuilder<R, A, V> _callBuilder;
  final UpdaterBuilder<A> _updaterBuilder;
  final ValueChanged<Exception> _onError;
  final QueryOnComplete<R> _onComplete;
  final QueryInitialDataBuilder<R, A> _initialDataBuilder;
  final bool _instantCall;
  final V _variable;

  /// Handle api calls inside widget structure
  Query({
    GlobalKey<QueryState<A, R, V>> key,
    QueryInitialDataBuilder<R, A> initialDataBuilder,
    @required QueryCallBuilder<R, A, V> callBuilder,
    @required QueryWidgetBuilder<R> builder,
    UpdaterBuilder<A> updaterBuilder,
    ValueChanged<Exception> onError,
    QueryOnComplete<R> onComplete,
    Duration interval,
    V variable,

    /// Whether [callBuilder] will be called right before first
    /// [builder] invocation defaults to `true`
    bool instantCall,
  })  : _builder = builder,
        _callBuilder = callBuilder,
        _interval = interval,
        _initialDataBuilder = initialDataBuilder,
        _updaterBuilder = updaterBuilder,
        _onError = onError,
        _onComplete = onComplete,
        _variable = variable,
        _instantCall = instantCall ?? true,
        super(key: key);

  @override
  QueryState createState() => QueryState<A, R, V>();

  /// Retrieve API created and provided by [RestuiProvider]
  static A of<A extends ApiBase>(BuildContext context) {
    return _InheritedRestuiProvider.of<A>(context)?.api;
  }
}

class QueryState<A extends ApiBase, R, V> extends State<Query<A, R, V>> {
  Caller<R> _caller;
  Listenable _updater;
  V _variable;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /// Called only once
    if (_caller == null) {
      _buildAndListenToUpdater();
      _createAndReplaceCaller();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Query<A, R, V> oldWidget) {
    if (widget._variable != oldWidget._variable) {
      /// Save variable from widget to state. (setState/rebuild is not needed)
      _variable = widget._variable;
    }
    if (widget._interval != oldWidget._interval) {
      /// dispose current caller
      _disposeCaller();

      /// replace old caller with new one
      _createAndReplaceCaller();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _buildAndListenToUpdater() {
    _buildUpdater();
    _listenToUpdater();
  }

  void _buildUpdater() {
    /// Retrieve API created and provided by [RestuiProvider]
    final api = Query.of<A>(context);

    /// Create updater from [updateBuilder] method if provided
    _updater = widget._updaterBuilder?.call(context, api);
  }

  /// Listen to [_updater] and rebuild widget every time when [_updater] notifies its' listeners
  void _listenToUpdater() {
    _updater?.addListener(_handleChange);
  }

  void _onComplete(R value) {
    widget._onComplete?.call(context, value);
  }

  /// Creates caller
  Caller<R> _createAndReplaceCaller() {
    /// Retrieve API created and provided by [RestuiProvider]
    final api = Query.of<A>(context);

    if (api == null) {
      throw ApiException(
        "Api cannot be null.\n"
        "Did you forget to wrap widgets tree with RestuiProvider?",
      );
    }

    return _caller = Caller<R>(
      /// variable is retrieve inside a closure what makes it possible to change
      /// its' value over time.
      () async => widget._callBuilder(context, api, _variable),
      interval: widget._interval,
      initialData: widget._initialDataBuilder?.call(context, api),
      instantCall: widget._instantCall,
      onError: widget._onError,

      /// [_onComplete] method will provide [BuildContext] to [onComplete]
      /// callback for consistency.
      onComplete: _onComplete,
    )..addListener(_handleChange);
  }

  /// rebuild widget when caller data changed
  void _handleChange() => setState(() {});

  /// Call [callBuilder] query and whole.
  ///
  /// When combined with [instantCall] set to `false` it's the only
  /// way of calling api by starting triggering query lifecycle.
  ///
  /// You can provide a variable which will be provided as the third
  /// argument to [callBuilder] function
  Future<R> call([V variable]) {
    /// assign provided variable (event if it is null)
    _variable = variable;

    /// Make call with updated variable
    final callFuture = _caller?.call();

    /// retrieve old variable for next calls
    _variable = widget._variable;
    return callFuture;
  }

  /// Replace old caller responsible for handling requests and widget updates
  /// with new one.
  ///
  /// It's useful when you want to change [onComplete] callback or
  /// even a [builder] method whose changes are not tracked by [Query] widget.
  ///
  /// [Query] widget only tracks changes of [interval] other changes
  /// will take no effect
  void updateCaller() {
    _disposeCaller();
    _createAndReplaceCaller();
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(context, _caller.loading, _caller.data);
  }

  void _unsubscribeFromUpdater() {
    _updater?.removeListener(_handleChange);
  }

  void _disposeCaller() {
    _caller?.removeListener(_handleChange);
    _caller?.dispose();
  }

  @override
  void dispose() {
    _unsubscribeFromUpdater();
    _disposeCaller();
    super.dispose();
  }
}
