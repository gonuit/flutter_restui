part of restui;

class ApiLinkUpdater<A extends ApiBase, L extends NotifierApiLink>
    extends Updater<A, L> {
  ApiLinkUpdater({
    Widget child,
    UpdaterTest<L> shouldUpdate,
  })  : assert(child != null, "child cannot be null"),
        super(
          child: child,
          shouldUpdate: shouldUpdate,
          updaterBuilder: (BuildContext context, A api) =>
              api.getFirstLinkOfType<L>(),
        );

  ApiLinkUpdater.builder({
    UpdaterWidgetBuilder<A, L> builder,
    UpdaterTest<L> shouldUpdate,
  })  : assert(builder != null, "builder cannot be null"),
        super.builder(
          builder: builder,
          shouldUpdate: shouldUpdate,
          updaterBuilder: (BuildContext context, A api) =>
              api.getFirstLinkOfType<L>(),
        );
}
