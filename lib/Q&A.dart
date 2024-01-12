import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QnA extends StatefulWidget {
  const QnA({Key? key}) : super(key: key);

  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  List<String> courseNames = [];
  String? selectedCourse;
  TextEditingController questionTextController = TextEditingController();
  TextEditingController solutionController = TextEditingController();

  // Function to fetch the list of courses
  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8888/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        setState(() {
          courseNames = List<String>.from(decodedData.map((courseData) {
            return courseData['courseName'];
          }));
        });
      } else {
        print("Failed to load courses. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  // Function to send question data to the backend
  Future<void> _sendQuestionToBackend(String courseName, String questionText, String solution) async {
    try {
      final courseId = await getCourseIdFromName(courseName);

      if (courseId != null) {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8888/questions?courseId=$courseId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'questionText': questionText,
            'solution': solution,
          }),
        );

        if (response.statusCode == 200) {
          print('Question submitted successfully');
        } else {
          print('Failed to submit question. Status code: ${response.statusCode}');
        }
      } else {
        print('Failed to obtain courseId for $courseName');
      }
    } catch (error) {
      print('Error submitting question: $error');
    }
  }

  // Function to get course ID from the course name
  Future<int?> getCourseIdFromName(String courseName) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8888/courses/$courseName/id'));

      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        print('Failed to get courseId. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error getting courseId: $error');
    }
    return null;
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
        title: Text('QnA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                setState(() {
                  selectedCourse = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: questionTextController,
              decoration: InputDecoration(labelText: 'Question Text'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: solutionController,
              decoration: InputDecoration(labelText: 'Solution'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedCourse != null) {
                  print('Selected Course: $selectedCourse');

                  // Get the text entered by the user
                  String questionText = questionTextController.text;
                  String solution = solutionController.text;

                  // Now you can send the question data along with the courseId to your backend
                  _sendQuestionToBackend(selectedCourse!, questionText, solution);
                } else {
                  print('No course selected');
                }
              },
              child: Text('Submit Q&A'),
            ),
          ],
        ),
      ),
    );
  }
}
