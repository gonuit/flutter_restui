part of restui;

class RestuiProvider<T extends ApiBase> extends StatefulWidget {
  final Widget child;

  final Create<T> create;
  RestuiProvider({
    @required this.child,
    @required this.create,
  });
  @override
  _RestuiProviderState<T> createState() => _RestuiProviderState<T>();
}

class _RestuiProviderState<T extends ApiBase> extends State<RestuiProvider> {
  T api;

  @override
  void didChangeDependencies() {
    /// build api only for the first time
    api ??= widget.create(context);
    assert(api != null, "API returned from create method cannot be null");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    api?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedRestuiProvider(
      api: api,
      child: widget.child,
    );
  }
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

  factory _InheritedRestuiProvider.of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedRestuiProvider>();
}
