import 'package:example/example_graphql_api.dart';
import 'package:example/screens/example_graphql_screen/pokemon_model.dart';
import 'package:flutter/material.dart';
import 'package:restui/restui.dart';

class GraphqlExampleScreen extends StatefulWidget {
  @override
  GraphqlExampleScreenState createState() => GraphqlExampleScreenState();
}

class GraphqlExampleScreenState extends State<GraphqlExampleScreen> {
  int _pokemonCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restui Graphql example")),
      body: SafeArea(
        child: Query<ExampleGraphqQlApi, List<PokemonModel>, int>(
          variable: _pokemonCount,
          callBuilder: (
            BuildContext context,
            ExampleGraphqQlApi api,
            int variable,
          ) async =>
              api.getPokemons(variable),
          builder: (BuildContext context, bool loading,
              List<PokemonModel> pokemons) {
            if (loading && pokemons == null)
              return Center(child: CircularProgressIndicator());

            if (pokemons == null) return Center(child: Text("No pokemons"));

            return Stack(
              children: <Widget>[
                ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (BuildContext context, int index) {
                    final pokemon = pokemons[index];
                    return Center(
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 300,
                                width: 300,
                                child: Image.network(pokemon.image),
                              ),
                              const SizedBox(height: 5),
                              Text(pokemon.name),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: pokemons.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                ),
                if (loading && pokemons != null)
                  const Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        heroTag: "FAB1",
        onPressed: () => setState(() => ++_pokemonCount),
      ),
    );
  }
}
