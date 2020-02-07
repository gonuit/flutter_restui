part of restui;

typedef ContextCreator<R> = R Function(BuildContext);

/// Provides API that extends [ApiBase] created by [apiBuilder]
/// down the widget tree.
///
/// It is required for the widget [Query] to work properly
/// 
/// API created by [apiBuilder] can be retrieved from children's
///  [BuildContext] by calling [Query.of<A extends ApiBase>(context)]
///  where [A] is yours API class name
class RestuiProvider<A extends ApiBase> extends StatefulWidget {
  final Widget _child;

  final ContextCreator<A> _apiBuilder;

  RestuiProvider({
    @required Widget child,
    @required ContextCreator<A> apiBuilder,
  })  : assert(
          apiBuilder != null,
          "Create method is required and connot be null"
          "as it is responsible for api creation",
        ),
        _child = child,
        _apiBuilder = apiBuilder;
  @override
  _RestuiProviderState<A> createState() => _RestuiProviderState<A>();
}

class _RestuiProviderState<A extends ApiBase> extends State<RestuiProvider> {
  A api;

  @override
  void didChangeDependencies() {
    /// build api only for the first time
    api ??= widget._apiBuilder(context);
    assert(api != null, "API returned from create method cannot be null");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    api?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedRestuiProvider<A>(
        api: api,
        child: widget._child,
      );
}

class _InheritedRestuiProvider<A extends ApiBase> extends InheritedWidget {
  _InheritedRestuiProvider({
    this.api,
    Widget child,
  }) : super(child: child);

  final A api;

  /// Notify widgets when api has been changed
  @override
  bool updateShouldNotify(_InheritedRestuiProvider oldWidget) =>
      api != oldWidget.api;

  static _InheritedRestuiProvider of<A extends ApiBase>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedRestuiProvider<A>>();
}
