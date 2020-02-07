part of rest_ui;

class RestUiProvider<T extends ApiBase> extends StatefulWidget {
  final Widget child;

  final Create<T> create;
  RestUiProvider({
    @required this.child,
    @required this.create,
  });
  @override
  _RestUiProviderState<T> createState() => _RestUiProviderState<T>();
}

class _RestUiProviderState<T extends ApiBase> extends State<RestUiProvider> {
  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: widget.create,
      dispose: (_, api) => api.dispose(),
      child: widget.child,
    );
  }
}
