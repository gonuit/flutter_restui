part of restui;

/// Api store witch change notifier
///
/// It can be use to refresh screen part by `NotifierApiStoreUpdater` widget
abstract class NotifierApiStore extends ApiStore with ChangeNotifier {}

/// Class for grouping api stores
abstract class ApiStore {}

/// Class responsible for keepieng data inside [ApiBase] class.
/// It allows managing the app state.
class ApiStorage {
  final List<ApiStore> _stores;
  ApiStorage([List<ApiStore> stores])
      : _stores = List.unmodifiable(stores ?? []);

  /// Returns first store of provided type
  T getFirstStoreOfType<T>() {
    for (var store in _stores) {
      if (store is T) return store as T;
    }
    return null;
  }

  /// Returns first store of provided type for which [test] has been passed
  T getFirstStoreOfTypeWhere<T extends ApiStore>(TestFunction<T> test) {
    for (var store in _stores) {
      if (store is T && test(store)) return store;
    }
    return null;
  }
}
