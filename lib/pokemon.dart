import 'dart:convert';
import 'package:http/http.dart' as http;
 
class Pokemon {
  final String name;
  final String imageUrl;
 
  Pokemon({required this.name, required this.imageUrl});
 
  static Future<List<Pokemon>> fetchPokemons() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var pokemonList = data['results'] as List;
      return Future.wait(pokemonList.map((pokemon) async {
        var detailResponse =
            await http.get(Uri.parse(pokemon['url'] as String));
        var detailData = jsonDecode(detailResponse.body);
        return Pokemon(
          name: pokemon['name'],
          imageUrl: detailData['sprites']['front_default'],
        );
      }));
    } else {
      throw Exception('Falha ao carregar dados do servidor');
    }
  }
}
 
