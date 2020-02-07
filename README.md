# Restui

A simple yet powerful wrapper around `http` library which
allows you to handle middlewares by `ApiLink`s (strongly inspired by apollo
graphQL client links) and use `Query` widget to make API calls right from the widgets tree.

## IMPORTANT
This library is under development, breaking API changes might still happen. If you would like to make use of this library please make sure to provide which version you want to use e.g:
```yaml
dependencies:
  restui: 0.1.0
```

- [Restui](#restui)
  - [IMPORTANT](#important)
  - [1. Getting Started](#1-getting-started)
      - [1.1. First create your Api object class by extending `BaseApi` class](#11-first-create-your-api-object-class-by-extending-baseapi-class)
      - [1.2. Provide your Api instance down the widget tree](#12-provide-your-api-instance-down-the-widget-tree)
      - [1.3.1. To make an api call in standard (ugly 😏) way](#131-to-make-an-api-call-in-standard-ugly-%f0%9f%98%8f-way)
      - [1.3.2. Or simply make use of `Query` widget to make the call from widget tree](#132-or-simply-make-use-of-query-widget-to-make-the-call-from-widget-tree)
  - [2. ApiLinks](#2-apilinks)
    - [2.1. About ApiLink](#21-about-apilink)
    - [2.2. Built-in ApiLinks](#22-built-in-apilinks)
      - [2.2.1. HeadersMapperLink](#221-headersmapperlink)
    - [2.3. Create own ApiLink](#23-create-own-apilink)
      - [2.3.1. Create link](#231-create-link)
      - [2.3.2. Get data from the link](#232-get-data-from-the-link)
  - [3. Example app](#3-example-app)
  - [4. TODO:](#4-todo)

## 1. Getting Started

#### 1.1. First create your Api object class by extending `BaseApi` class
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

#### 1.2. Provide your Api instance down the widget tree
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /// To provide your api use [RestuiProvider] widget
    /// in place of [Api] put yours API class type 
    return RestuiProvider<Api>(
        apiBuilder: (_) => Api(

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

#### 1.3.1. To make an api call in standard (ugly 😏) way
```dart
class _ApiExampleScreenState extends State<ApiExampleScreen> {
  ExamplePhotoModel _randomPhoto;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _requestRandomPhoto();
    })
    super.initState();
  }

  Future<ExamplePhotoModel> _requestRandomPhoto() async {
    
    /// Retrieve api instance from context
    final api = Query.of<Api>(context);

    /// Make API request
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
#### 1.3.2. Or simply make use of `Query` widget to make the call from widget tree
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

## 2. ApiLinks

### 2.1. About ApiLink
`ApiLink` object is kind of a middleware that enables you to add some custom
behaviour before and after every API request.
  
Links can be then Retrieved from your API class [MORE](#22-get-data-from-the-link).

### 2.2. Built-in ApiLinks

#### 2.2.1. HeadersMapperLink
This [ApiLink] takes headers specified by [headersToMap] argument
from response headers and then put to the next request headers.
  
It can be used for authorization. For example,we have an `authorization`
header that changes after each request and with the next query we
must send it back in headers. This [ApiLink] will take it from the
response, save and set as a next request header.
  
Example use simple as:
```dart
final api = Api(
  uri: Uri.parse("https://picsum.photos"),
  link: HeadersMapperLink(["authorization"]),
);
```


### 2.3. Create own ApiLink
If you want to create your own ApiLink with custom behaviour all you need to do is to create your link class that extend `ApiLink` class and then pass it to your api super constructor (constructor of `ApiBase` class) (e.g. [[1](#1-first-create-your-api-object-class-by-extending-baseapi-class)] [[2](#2-provide-your-api-instance-down-the-widget-tree)]).

#### 2.3.1. Create link
```dart
class OngoingRequestsCounterLink extends ApiLink {
  int ongoingRequests;

  OngoingRequestsCounterLink() : _requests = 0;

  /// All you need to do is to override [next] method and add your
  /// custom behaviour
  @override
  Future<ApiResponse> next(ApiRequest request) async {
    
    /// Code here will be called `BEFORE` request
    ongoingRequests++;

    /// Calling [super.next] is required. It calls next [ApiLink]s in the 
    /// chain and returns with [ApiResponse]. 
    ApiResponse response = await super.next(request);

    /// Code here will be called `AFTER` request
    ongoingRequests--;

    /// [next] method should return [ApiResponse] as it passes it down the
    /// [ApiLink] chain
    return response;
  }
}
```

#### 2.3.2. Get data from the link 
Sometimes there is a need to retrieve data saved inside a link or pass some data into it. This is possible thanks to the:
```dart
/// Retrieve `Api` instance from the tree
Api api = Query.of<Api>(context);

/// Get first link of provided type
OngoingRequestsCounterLink link = Api.getFirstLinkOfType<OngoingRequestsCounterLink>();

/// Do sth with your link data
print(link.ongoingRequests);
```
`Api` should be replaced with your API class name that extends `ApiBase`.

## 3. Example app
Inside `example` directory you can find an example app and play with this library.
![screen](./example/screen.png)
  
## 4. TODO:
  - Tests
  - Improve readme
  - Add `CacheLink` which will be responsible for request caching