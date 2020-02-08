part of restui;

class ApiStoreUpdater<A extends ApiBase, L extends NotifierApiStore>
    extends Updater<A, L> {
  ApiStoreUpdater({
    Widget child,
    UpdaterTest<L> shouldUpdate,
  })  : assert(child != null, "child cannot be null"),
        super(
          child: child,
          shouldUpdate: shouldUpdate,
          updaterBuilder: (BuildContext context, A api) =>
              api.storage.getFirstStoreOfType<L>(),
        );

  ApiStoreUpdater.builder({
    UpdaterWidgetBuilder<A, L> builder,
    UpdaterTest<L> shouldUpdate,
  })  : assert(builder != null, "builder cannot be null"),
        super.builder(
          builder: builder,
          shouldUpdate: shouldUpdate,
          updaterBuilder: (BuildContext context, A api) =>
              api.storage.getFirstStoreOfType<L>(),
        );
}
