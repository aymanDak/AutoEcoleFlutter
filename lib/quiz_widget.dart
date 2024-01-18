import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: QuizWidget(),
  ));
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({Key? key}) : super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  bool showSolution = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final response = await http.get(Uri.parse('http://localhost:8888/questions'));

    if (response.statusCode == 200) {
      setState(() {
        questions = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
      showSolution = false;
    });
  }

  void _showSolution() {
    setState(() {
      showSolution = true;
    });
  }

  String get currentQuestionText =>
      questions[currentQuestionIndex]['questionText'] as String;
  String get currentSolutionText =>
      questions[currentQuestionIndex]['solution'] as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (questions.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}/${questions.length}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              currentQuestionText,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (showSolution)
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Solution:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                currentSolutionText,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: showSolution ? _nextQuestion : _showSolution,
                      child: Text(showSolution ? 'Next Question' : 'Show Solution'),
                    ),
                  ],
                ),
              if (questions.isEmpty)
                Text(
                  'No questions available.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
