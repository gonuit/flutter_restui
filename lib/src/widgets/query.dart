part of restui;

typedef QueryBuilder<T> = Widget Function(
  BuildContext context,
  bool loading,
  T response,
);
typedef QueryCallBuilder<R, A> = Future<R> Function(
    BuildContext context, A api);

typedef QueryOnComplete<V> = void Function(BuildContext context, V value);

/// Widget responsible for refreshing part of the tree with updated data
///
/// If you want to have full controll when [callBuilder] will be called.
/// Provide this widget with a key argument of type `GlobalKey<QueryState<R,A>>`.
/// Then you can trigger the query lifecycle by `call` method invocation on
/// [QueryState] object. It could be useful e.g. when you want to upload
/// a file and you want to do this only once right after its selection.
class Query<R, A extends ApiBase> extends StatefulWidget {
  final QueryBuilder<R> _builder;
  final Duration _interval;
  final QueryCallBuilder<R, A> _callBuilder;
  final QueryOnComplete<R> _onComplete;
  final R _initialData;
  final bool _instantCall;

  /// Handle api calls inside widget structure
  Query({
    Key key,
    @required QueryBuilder<R> builder,
    @required QueryCallBuilder<R, A> callBuilder,
    QueryOnComplete<R> onComplete,
    R initialData,
    Duration interval,

    /// Whether [callBuilder] will be called right before first
    /// [builder] invocation defaults to `true`
    bool instantCall,
  })  : _builder = builder,
        _callBuilder = callBuilder,
        _interval = interval,
        _initialData = initialData,
        _onComplete = onComplete,
        _instantCall = instantCall ?? true,
        super(key: key);

  @override
  QueryState createState() => QueryState<R, A>();

  /// Retrieve API created and provided by [RestuiProvider]
  static A of<A extends ApiBase>(BuildContext context) {
    return _InheritedRestuiProvider.of<A>(context)?.api;
  }
}

class QueryState<R, A extends ApiBase> extends State<Query<R, A>> {
  Caller<R> _caller;

  @override
  void didChangeDependencies() {
    if (_caller == null) {
      _createAndReplaceCaller();
    }
    super.didChangeDependencies();
  }

  /// Return closure with [BuildContext] that calls original [onComplete]
  /// method if it is available otherwise returns null.
  ValueChanged<R> _getOnCompleteCallback(BuildContext context) =>
      widget._onComplete != null
          ? (R value) => widget._onComplete(context, value)
          : null;

  /// Creates caller
  Caller<R> _createAndReplaceCaller() {
    /// Retrieve API created and provided by [RestuiProvider]
    final api = Query.of<A>(context);

    if (api == null)
      throw ApiException(
        "Api cannot be null.\n"
        "Did you forget to wrap widgets tree with RestuiProvider?",
      );
    return _caller = Caller<R>(
      () async => widget._callBuilder(context, api),
      interval: widget._interval,
      initialData: widget._initialData,
      instantCall: widget._instantCall,

      /// Adds context to onComplete method
      onComplete: _getOnCompleteCallback(context),
    )..addListener(_handleChange);
  }

  /// rebuild widget when caller data changed
  void _handleChange() => setState(() {});

  /// Call [callBuilder] query and whole.
  ///
  /// When combined with [instantCall] set to `false` it's the only
  /// way of calling api by starting triggering query lifecycle.
  void call() {
    _caller?.call();
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
  void didUpdateWidget(Query<R, A> oldWidget) {
    if (widget._interval != oldWidget._interval) {
      /// dispose current caller
      _disposeCaller();

      /// replace old caller with new one
      _createAndReplaceCaller();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(context, _caller.loading, _caller.data);
  }

  void _disposeCaller() {
    _caller?.dispose();
  }

  @override
  void dispose() {
    _disposeCaller();
    super.dispose();
  }
}
