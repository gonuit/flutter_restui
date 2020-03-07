part of restui;

@experimental
typedef GraphqlCallBuilder<A extends GraphqlApiBase, R> = GraphqlRequest<R>
    Function(BuildContext context, A api);
@experimental
typedef GraphqlWidgetBuilder<R> = Widget Function(
  BuildContext context,
  GraphqlResponse data,
  Object error, {
  GraphqlResponseDecoder<R> decoder,
});

/// TODO: add support for variables
@experimental
class Graphql<A extends GraphqlApiBase, R> extends StatefulWidget {
  final GraphqlCallBuilder<A, R> callBuilder;
  final GraphqlWidgetBuilder<R> builder;

  Graphql({
    @required this.callBuilder,
    @required this.builder,
  });

  @override
  _GraphqlState<A, R> createState() => _GraphqlState<A, R>();
}

class _GraphqlState<A extends GraphqlApiBase, R> extends State<Graphql<A, R>> {
  Stream<GraphqlResponse> _stream;
  GraphqlRequest<R> _request;

  @override
  void didChangeDependencies() {
    final api = Query.of<A>(context);
    _request = widget.callBuilder(context, api);
    _stream ??= _request.callWithCache();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GraphqlResponse>(
      stream: _stream,
      builder: (context, snapshot) {
        return widget.builder(
          context,
          snapshot?.data,
          snapshot?.error,
          decoder: _request.decoder,
        );
      },
    );
  }
}
