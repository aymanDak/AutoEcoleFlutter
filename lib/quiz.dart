import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<String> courseNames = [];
  String selectedCourse = ''; // Provide a default value

  // Function to fetch the list of courses
  Future<void> _fetchCourses() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8888/courses'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);

      setState(() {
        courseNames = List<String>.from(decodedData.map((courseData) => courseData['courseName']));
      });
    } else {
      print("Failed to load courses. Status code: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch courses when the widget is initialized
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input for Course - Dropdown
            DropdownButton<String>(
              value: selectedCourse,
              hint: Text('Select a course'),
              items: courseNames.map((String course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                }
              },
            ),
            SizedBox(height: 16),

            // Input for User
            TextField(
              decoration: InputDecoration(labelText: 'User'),
              // Handle onChanged or controller to get input value
            ),
            SizedBox(height: 16),

            // You can add more inputs or customize as needed

            ElevatedButton(
              onPressed: () {
                // Handle the button press to submit the quiz
                // Access the input values and perform actions
                print('Selected Course: $selectedCourse');
              },
              child: Text('Submit Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
