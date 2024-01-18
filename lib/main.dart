import 'package:autoecoleproject/Q&A.dart';
import 'package:autoecoleproject/cours.dart';
import 'package:autoecoleproject/login.dart';
import 'package:autoecoleproject/dashboard.dart';
import 'package:autoecoleproject/pallete.dart';
import 'package:autoecoleproject/quiz.dart';
import 'package:autoecoleproject/quiz_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoEcole',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/dashboard': (context) => Dashboard(),
        '/cours': (context) => Cours(), // Replace with your actual CoursScreen widget
        '/quiz_widget': (context) => QuizWidget(), // Replace with your actual CoursScreen widget

        //'/client': (context) => ClientScreen(), // Replace with your actual ClientScreen widget
        //'/moniteur': (context) => MoniteurScreen(), // Replace with your actual MoniteurScreen widget
        '/Q&A': (context) => QnA(), // Replace with your actual QuizScreen widget
      },
    );
  }
}
