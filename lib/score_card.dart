import 'package:flutter/material.dart';
 
class ScoreCard extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
 
  ScoreCard({required this.correctAnswers, required this.wrongAnswers});
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScoreItem('Corretas', correctAnswers, Colors.green),
        SizedBox(width: 20),
        _buildScoreItem('Erradas', wrongAnswers, Colors.red),
      ],
    );
  }
 
  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: color),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
