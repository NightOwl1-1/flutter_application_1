import 'dart:math';
import 'package:flutter/material.dart';
import 'pokemon.dart';

class QuizLogic {
  final List<Pokemon> allPokemons;
  int _currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  static const int MAX_QUESTIONS = 10;

  late Pokemon correctPokemon;
  List<Pokemon> randomPokemons = [];

  QuizLogic(this.allPokemons) {
    _getRandomPokemons();
  }

  bool checkAnswer(Pokemon chosenPokemon) {
    final isCorrect = chosenPokemon == correctPokemon;
    if (isCorrect) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }
    return isCorrect;
  }

  bool isGameOver() {
    return _currentQuestionIndex >= MAX_QUESTIONS;
  }

  void reset() {
    _currentQuestionIndex = 0;
    correctAnswers = 0;
    wrongAnswers = 0;
    _getRandomPokemons();
  }

  void nextQuestion() {
    if (!isGameOver()) {
      _currentQuestionIndex++;
      _getRandomPokemons();
    }
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
