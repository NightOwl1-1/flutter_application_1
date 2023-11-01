import 'dart:math';
import 'package:flutter/material.dart';
import 'pokemon.dart';

class QuizLogic {
  final List<Pokemon> allPokemons;
  int _currentQuestionIndex = 0;
  int score = 0;
  bool gameOver = false;

  static const int MAX_QUESTIONS = 10;

  late Pokemon correctPokemon;
  List<Pokemon> randomPokemons = [];

  QuizLogic(this.allPokemons) {
    _getRandomPokemons();
  }

  void reset() {
    _currentQuestionIndex = 0;
    score = 0;
    gameOver = false;
    _loadQuestion();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < MAX_QUESTIONS - 1) {
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
        gameOver = true;
      }
      return true;
    }
    return false;
  }

  bool isGameOver() {
    return gameOver;
  }

  void _loadQuestion() {
    _getRandomPokemons();
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
