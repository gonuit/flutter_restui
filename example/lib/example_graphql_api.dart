import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

import 'screens/example_graphql_screen/pokemon_model.dart';

class ExampleGraphqQlApi extends GraphqlApiBase {
  ExampleGraphqQlApi({
    @required Uri uri,
    ApiLink link,
    Map<String, String> defaultHeaders,
  }) : super(
          uri: uri,
          defaultHeaders: defaultHeaders,
          link: link,
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
