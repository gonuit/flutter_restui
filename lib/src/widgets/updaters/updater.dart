part of restui;

class Updater<A extends ApiBase, L extends Listenable> extends StatefulWidget {
  final UpdaterBuilder<A> _updaterBuilder;
  final Widget _child;
  final UpdaterWidgetBuilder<A, L> _builder;
  final UpdaterTest<L> _shouldUpdate;

  Updater({
    Widget child,
    UpdaterTest<L> shouldUpdate,
    UpdaterBuilder<A> updaterBuilder,
  })  : assert(child != null, "child cannot be null"),
        assert(updaterBuilder != null, "updaterBuilder cannot be null"),
        _updaterBuilder = updaterBuilder,
        _child = child,
        _shouldUpdate = shouldUpdate,
        _builder = null;

  Updater.builder({
    UpdaterBuilder<A> updaterBuilder,
    UpdaterWidgetBuilder<A, L> builder,
    UpdaterTest<L> shouldUpdate,
  })  : assert(builder != null, "builder cannot be null"),
        assert(updaterBuilder != null, "updaterBuilder cannot be null"),
        _updaterBuilder = updaterBuilder,
        _child = null,
        _shouldUpdate = shouldUpdate,
        _builder = builder;
  @override
  _UpdaterState<A, L> createState() => _UpdaterState<A, L>();
}

class _UpdaterState<A extends ApiBase, L extends Listenable>
    extends State<Updater<A, L>> {
  Listenable _updater;
  void didChangeDependencies() {
    if (_updater == null) {
      final api = Query.of<A>(context);
      _updater = widget._updaterBuilder(context, api);
      assert(
        _updater != null,
        "NotifierApiLink was not provided.\n"
        "Did you forget to assign it to ApiBase?",
      );
      _updater?.addListener(_handleChange);
    }

    super.didChangeDependencies();
  }

  void _handleChange() {
    /// Do not update widget when [shouldUpdate] return false
    if (widget._shouldUpdate?.call(_updater) != false) setState(() {});
  }

  @override
  void dispose() {
    _updater?.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final api = Query.of<A>(context);
    return widget._child != null
        ? widget._child
        : widget._builder(context, api, _updater);
  }
}
