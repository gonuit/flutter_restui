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
  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: widget.create,
      dispose: (_, api) => api.dispose(),
      child: widget.child,
    );
  }
}
