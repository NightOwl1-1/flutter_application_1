import 'dart:math';
import 'pokemon.dart';

class QuizLogic {
  final List<Pokemon> allPokemons;
  int _currentQuestionIndex = 0;
  int score = 0;
  bool gameOver = false;

  static const int MAX_QUESTIONS = 10; // Definir o número máximo de perguntas

  late Pokemon correctPokemon;
  List<Pokemon> randomPokemons = [];

  QuizLogic(this.allPokemons) {
    _getRandomPokemons();
  }

  void reset() {
    _currentQuestionIndex = 0;
    score = 0;
    gameOver = false; // Adicione esta linha
    _loadQuestion();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < MAX_QUESTIONS - 1) {
      // Modificar esta linha
      _currentQuestionIndex++;
      _loadQuestion();
    } else {
      gameOver = true;
    }
  }

  bool checkAnswer(Pokemon chosenPokemon) {
    if (chosenPokemon == correctPokemon) {
      score++;
      if (_currentQuestionIndex == MAX_QUESTIONS - 1) {
        // Adicione esta condição
        gameOver = true;
        return false; // O jogo terminou mesmo que a resposta esteja correta
      }
      return true;
    }
    return false;
  }

  bool isGameOver() {
    return gameOver;
  }

  void _loadQuestion() {
    _getRandomPokemons(); // Lógica para carregar a próxima pergunta.
  }

  void _getRandomPokemons() {
    final random = Random();
    correctPokemon = allPokemons[random.nextInt(allPokemons.length)];
    randomPokemons = [correctPokemon];

    while (randomPokemons.length < 4) {
      final randomOption = allPokemons[random.nextInt(allPokemons.length)];
      if (!randomPokemons.contains(randomOption)) {
        randomPokemons.add(randomOption);
      }
    }

    randomPokemons.shuffle();
  }
}
