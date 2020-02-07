# Restui

A simple yet powerful wrapper around `http` and `provider` libraries which
allows you to handle middlewares by `ApiLink`s (strongly inspired by apollo
graphQL client links) and use `Query` widget to make API calls right from the widgets tree.

## Getting Started

#### 1. First create your Api object class by extending `BaseApi` class
```dart
class Api extends ApiBase {

  Api({
    /// BaseApi requires yoy to provide [Uri] object that points to your api 
    @required Uri uri,

    /// Enable link support by passing [ApiLink]
    /// object to super constructor (optional)
    ApiLink link,

    /// Default headers for your application (optional)
    Map<String, String> defaultHeaders,

    /// Call super constructor with provided data
  }) : super(uri: uri, defaultHeaders: defaultHeaders, link: link) {
    _photos = _PhotoQueries(this);
  }

  /// Implement methods that will call your api
  Future<ExamplePhotoModel> getRandomPhoto() async {

    /// It's important to call your api with [call] method as it triggers
    /// [ApiRequest] build and links invokations
    final response = await api.call(
      endpoint: "/id/${Random().nextInt(50)}/info",
      method: HttpMethod.GET,
    );
    return ExamplePhotoModel.fromJson(json.decode(response.body));
  }
}

```

#### 2 Provide your Api instance down the widget tree
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To provide your api use [RestuiProvider] widget or
    /// [Provider] from [provider] package
    /// in place of `<Api>` put your api class name / type
    return RestuiProvider<Api>(
        create: (_) => Api(
          /// Pass base uri adress thats points to your api
          uri: Uri.parse("https://picsum.photos"),
          /// Add links if needed
          /// For more invormation look at [HeadersMapperLink] and [DebugLink]
          /// links descriptions
          link: HeadersMapperLink(["uid", "client", "access-token"])
              .chain(DebugLink(printResponseBody: true)),
        ),
        child: MaterialApp(
          title: 'flutter_starter_app',
          onGenerateRoute: _generateRoute,
        ),
      );
  }
}
```

#### 3.1 To make an api call in standard way
```dart
class _ApiExampleScreenState extends State<ApiExampleScreen> {
  ExamplePhotoModel _randomPhoto;

  @override
  void initState() {
    _requestRandomPhoto();
    super.initState();
  }

  Future<ExamplePhotoModel> _requestRandomPhoto() async {
    final api = Provider.of<Api>(context);
    final photo = await api.getRandomPhoto();
    setState({
      _randomPhoto = photo;
    })
  }

  @override
  Widget build(BuildContext context) {
    bool hasPhotot = _randomPhoto != null;
    return Center(
      /// Implementation ...
    );
  }
}
```
#### 3.2 Or simply make use of `Query` widget to make the call from widget tree
```dart
class _ApiExampleScreenState extends State<ApiExampleScreen> {
 
  @override
  Widget build(BuildContext context) {
    bool hasPhotot = _randomPhoto != null;

    /// Create [Query] widget and declare types for its
    /// `<TypeToBeReturnedFromCallBuilder, YouApiType>`
    return Query<ExamplePhotoModel, Api>(
      
      /// [callBuilder] is responsible for getting data.
      /// You can also combine it with your BloC object
      /// to prevent api calls when data exists.
      callBuilder: (BuildContext context, Api api) => api.photos.getRandom(),

      /// [onComplete] callback is called right after [callBuilder] with
      /// the data returned from it.. 
      /// [onComplete] method is called right before [builder] invocation.
      /// It's a great place for BloC/cache data update.
      onComplete: (BuildContext context, ExamplePhotoModel photo) {
         /// Implementation ...
      },

      /// Data which will be passed as [value] argument to [builder] method
      /// when [callBuilder] does not return the value yet.
      initialData: myExamplePhotoModelInitialValue,

      /// Specifying [interval] will cause the query to be
      /// called periodically every [interval] of time.
      interval: const Duration(seconds: 10),

      /// [value] will be [null] or [initialData] (if argument provided) untill
      /// first value are returned from [callBuilder].
      /// [loading] indicates whether [callBuilder] method is ongoing.
      builder: (BuildContext context, bool loading, ExamplePhotoModel value) {
        return Center(
          /// Implementation ...
        );
      },
    );
  }
}
```
