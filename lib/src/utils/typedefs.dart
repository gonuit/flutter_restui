part of restui;

typedef TestFunction<T extends ApiStore> = bool Function(T value);

/// RestuiProvider

typedef ContextCreator<R> = R Function(BuildContext);

/// Updaters

typedef UpdaterWidgetBuilder<A extends ApiBase, L extends Listenable> = Widget
    Function(BuildContext context, A api, L link);

typedef UpdaterTest<T> = bool Function(T value);

/// Query

typedef QueryWidgetBuilder<T> = Widget Function(
  BuildContext context,
  bool loading,
  T response,
);
typedef QueryCallBuilder<R, A extends ApiBase, V> = Future<R> Function(
    BuildContext context, A api, V variable);

typedef QueryInitialDataBuilder<R, A extends ApiBase> = R Function(
    BuildContext context, A api);

typedef UpdaterBuilder<A extends ApiBase> = Listenable Function(
    BuildContext context, A api);

typedef QueryOnComplete<V> = void Function(BuildContext context, V value);

typedef QueryShouldUpdate<A extends ApiBase, V> = bool Function(
    BuildContext context, A api, V value);
