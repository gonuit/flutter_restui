import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

import 'screens/example_graphql_screen/pokemon_model.dart';

class ExampleGraphqQlApi extends GraphqlApi {
  ExampleGraphqQlApi({
    @required Uri uri,
    ApiLink link,
    List<ApiStore> stores,
    Map<String, String> defaultHeaders,
  }) : super(
          uri: uri,
          defaultHeaders: defaultHeaders,
          link: link,
          stores: stores,
        );

  Future<List<PokemonModel>> getPokemons(int count) async {
    final response = await query(GraphqlRequest(
        query: "{pokemons(first: $count) {id,name,image,}}".trim(),
        operationName: null,
        variables: null));

    if (response.errors != null) {
      print("EMPTY!");
    }
    final pokemnos = (response.data["pokemons"] as List)
        .map((pokemon) => PokemonModel.fromJson(pokemon))
        .toList();
    return pokemnos;
  }
}
