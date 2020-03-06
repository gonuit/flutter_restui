import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:restui/restui.dart';

import 'example_photo_model.dart';

class ExampleApi extends ApiBase {
  _PhotoQueries _photos;
  _PhotoQueries get photos => _photos;

  ExampleApi({
    @required Uri uri,
    ApiLink link,
    List<ApiStore> stores,
    Map<String, String> defaultHeaders,
  }) : super(
          uri: uri,
          defaultHeaders: defaultHeaders,
          link: link,
          stores: stores,
        ) {
    _photos = _PhotoQueries(this);
  }
}

class _PhotoQueries {
  ExampleApi api;
  _PhotoQueries(this.api);

  Future<ExamplePhotoModel> getRandom() async {
    final apiResponse = await api.call(
      endpoint: "/id/${Random().nextInt(50)}/info",
      method: HttpMethod.get,
    );
    return ExamplePhotoModel.fromJson(
      json.decode(apiResponse.body),
    );
  }

  Future<ExamplePhotoModel> getById(String id) async {
    final apiResponse = await api.call(
      endpoint: "/id/$id/info",
      method: HttpMethod.get,
    );
    return ExamplePhotoModel.fromJson(
      json.decode(apiResponse.body),
    );
  }
}
