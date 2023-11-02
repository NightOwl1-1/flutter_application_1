import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'quiz.logic.dart';
import 'score_card.dart';
 
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
                ? _buildResultWidget()
                : _buildQuestionWidget(),
      ),
    );
  }
 
  Widget _buildQuestionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.network(
            quiz.correctPokemon.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
        ...quiz.randomPokemons.map((pokemon) => _buildButton(pokemon)).toList(),
        ScoreCard(
          correctAnswers: quiz.correctAnswers,
          wrongAnswers: quiz.wrongAnswers,
        ),
      ],
    );
  }
 
  Widget _buildButton(Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          final isCorrect = quiz.checkAnswer(pokemon);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(isCorrect ? 'Resposta Correta!' : 'Resposta Errada!'),
            duration: Duration(seconds: 1),
          ));
          setState(() {
            quiz.nextQuestion();
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            pokemon.name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildResultWidget() {
    if (quiz != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Quiz Finalizado!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Respostas Corretas: ${quiz.correctAnswers}',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          Text(
            'Respostas Erradas: ${quiz.wrongAnswers}',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                quiz.reset();
              });
            },
            child: Text('Tentar de novo?'),
          ),
        ],
      );
    } else {
      return CircularProgressIndicator(); //Mostra um indicador de progresso até que o quiz seja inicializado.
    }
  }
}
