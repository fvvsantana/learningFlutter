import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

// void main(){
// runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const _questions = [
    {
      'question': 'What\'s your favorite color?',
      'answers': ['Red', 'Green', 'Blue'],
    },
    {
      'question': 'What\'s your favorite animal?',
      'answers': ['Rabbit', 'Elephant', 'Monkey'],
    },
    {
      'question': 'What\'s your favorite instructor?',
      'answers': ['Max', 'Max', 'Max'],
    },
  ];

  int _questionIndex = 0;

  void _answerQuestion() {
    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My first app'),
        ),
        body: _questionIndex < _questions.length
            ? Column(
                children: [
                  Question(_questions[_questionIndex]['question']),
                  ...(_questions[_questionIndex]['answers'] as List<String>)
                      .map((answer) => Answer(answer, _answerQuestion)),
                ],
              )
            : Center(
                child: Text('You did it!'),
              ),
      ),
    );
  }
}
