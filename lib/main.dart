import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'quiz.logic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonQuizPage(),
    );
  }
}

class PokemonQuizPage extends StatefulWidget {
  @override
  _PokemonQuizPageState createState() => _PokemonQuizPageState();
}

class _PokemonQuizPageState extends State<PokemonQuizPage> {
  late QuizLogic quiz;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: Pokemon.fetchPokemons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            quiz = QuizLogic(snapshot.data!); // Removido o "if (quiz == null)"

            return Scaffold(
              appBar: AppBar(title: Text('Pokémon Quiz')),
              body: quiz.isGameOver()
                  ? Center(child: Text('Game Over! Your score: ${quiz.score}'))
                  : Column(
                      children: <Widget>[
                        Image.network(quiz.correctPokemon.imageUrl),
                        ...quiz.randomPokemons
                            .map((pokemon) => ElevatedButton(
                                  child: Text(pokemon.name),
                                  onPressed: () {
                                    final isCorrect = quiz.checkAnswer(pokemon);
                                    if (isCorrect) {
                                      quiz.nextQuestion();
                                    } else {
                                      if (quiz.isGameOver()) {
                                        // Mostrar diálogo de fim de jogo ou redirecionar
                                      }
                                    }
                                    setState(() {});
                                  },
                                ))
                            .toList(),
                      ],
                    ),
            );
          } else {
            return Center(child: Text('Error loading pokemons!'));
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
