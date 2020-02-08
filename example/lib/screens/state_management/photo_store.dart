import 'package:example/example_photo_model.dart';
import 'package:restui/restui.dart';

class PhotoStore extends NotifierApiStore {
  final List<ExamplePhotoModel> _photos = [];
  List<ExamplePhotoModel> get photos => List.unmodifiable(_photos);

  void addPhoto(ExamplePhotoModel photo) {
    _photos.add(photo);
    notifyListeners();
  }

  void removePhotoById(String photoId) {
    _photos.removeWhere((photo) => photo.id == photoId);
    notifyListeners();
  }

  void clear() {
    if (photos.isEmpty) return;
    _photos.clear();
  }

  bool hasPhotoOfId(String photoId) =>
      _photos.firstWhere(
        (storedPhoto) => storedPhoto.id == photoId,
        orElse: () => null,
      ) !=
      null;
}
