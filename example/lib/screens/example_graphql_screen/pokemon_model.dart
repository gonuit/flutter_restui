class PokemonModel {
  final String id;
  final String name;
  final String image;

  PokemonModel.fromJson(dynamic jsonMap)
      : id = jsonMap["id"],
        name = jsonMap["name"],
        image = jsonMap["image"];
}
