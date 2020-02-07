part of restui;

typedef QueryBuilder<T> = Widget Function(
  BuildContext context,
  bool loading,
  T response,
);
typedef QueryCallBuilder<R, A> = Future<R> Function(
    BuildContext context, A api);

class Query<R, A extends ApiBase> extends StatefulWidget {
  final QueryBuilder<R> _builder;
  final Duration _interval;
  final QueryCallBuilder<R, A> _callBuilder;
  final ValueChanged<R> _onComplete;
  final R _initialData;

  /// Handle api calls inside widget structure
  Query({
    Key key,
    @required QueryBuilder<R> builder,
    @required QueryCallBuilder<R, A> callBuilder,
    ValueChanged<R> onComplete,
    R initialData,
    Duration interval,
  })  : _builder = builder,
        _callBuilder = callBuilder,
        _interval = interval,
        _initialData = initialData,
        _onComplete = onComplete,
        super(key: key);

  @override
  QueryState createState() => QueryState<R, A>();
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

  /// Creates caller
  Caller<R> _createAndReplaceCaller() {
    final api = Provider.of<A>(context);
    return _caller = Caller<R>(
      () async => widget._callBuilder(context, api),
      interval: widget._interval,
      initialData: widget._initialData,
      onComplete: widget._onComplete,
    )..addListener(_handleChange);
  }

  /// rebuild widget when caller data changed
  void _handleChange() => setState(() {});

  /// Call [callBuilder] query
  void call() {
    _caller?.call();
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
