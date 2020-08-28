import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int _totalScore;
  final Function _resetQuiz;

  Result(this._totalScore, this._resetQuiz);

  String get resultPhrase {
    String resultText;
    if (_totalScore <= 8) {
      resultText = 'You are awesome and innocent!';
    } else if (_totalScore <= 12) {
      resultText = 'You are pretty likeable!';
    } else if (_totalScore <= 16) {
      resultText = 'You are ... strange!';
    } else {
      resultText = 'You\'re so bad!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            resultPhrase,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: _resetQuiz,
          child: Text(
            'Reset quiz',
            style: TextStyle(color: Colors.blue,),
          ),
        ),
      ],
    );
  }
}
