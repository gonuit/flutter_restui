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

  GraphqlRequest<List<PokemonModel>> getPokemons(int count) {
    return GraphqlRequest(
      api: this,
      query: "{pokemons(first: $count) {id,name,image,}}".trim(),
      operationName: null,
      variables: null,
      decoder: (GraphqlResponse response) {
        if (response.errors != null) {
          return null;
        }
        final pokemons = (response.data["pokemons"] as List)
            .map((pokemon) => PokemonModel.fromJson(pokemon))
            .toList();

        return pokemons;
      },
    );
  }
}
