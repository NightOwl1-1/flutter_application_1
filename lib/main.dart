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
  void initState() {
    super.initState();
    Pokemon.fetchPokemons().then((pokemons) {
      setState(() {
        quiz = QuizLogic(pokemons);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Quiz')),
      body: Center(
        child: quiz == null
            ? CircularProgressIndicator()
            : quiz.isGameOver()
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Game Over! Your score: ${quiz.score}',
                          style: TextStyle(fontSize: 20)),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            quiz.reset();
                          });
                        },
                        child: Text('Play Again'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.network(
                          quiz.correctPokemon.imageUrl,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                      ...quiz.randomPokemons
                          .map((pokemon) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    final isCorrect = quiz.checkAnswer(pokemon);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        isCorrect
                                            ? 'Correct!'
                                            : 'Wrong! Try again.',
                                      ),
                                      duration: Duration(seconds: 1),
                                    ));
                                    if (isCorrect) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        setState(() {
                                          quiz.nextQuestion();
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        pokemon.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
      ),
    );
  }
}
