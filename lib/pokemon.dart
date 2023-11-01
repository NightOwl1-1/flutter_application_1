import 'dart:convert';
import 'package:http/http.dart' as http;

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  static Future<List<Pokemon>> fetchPokemons() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150'));
    final List<Pokemon> pokemons = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data['results']) {
        final pokemonDetail = await http.get(Uri.parse(item['url']));
        var detailData = jsonDecode(pokemonDetail.body);
        pokemons.add(Pokemon(
            name: item['name'],
            imageUrl: detailData['sprites']['front_default']));
      }
    }
    return pokemons;
  }
}
