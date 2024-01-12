import 'package:flutter/material.dart';
import 'AddCourseForm.dart'; // Make sure to import the AddCourseForm
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cours extends StatefulWidget {
  const Cours({Key? key}) : super(key: key);

  @override
  _CoursState createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  List<String> courseNames = []; // List to store course names

  // Function to fetch the list of courses
  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8888/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        setState(() {
          // Extract course names from the fetched data
          courseNames = List<String>.from(decodedData.map((courseData) => courseData['courseName']));
        });
      } else {
        print("Failed to load courses. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  // Function to show the Add Course dialog
  void _showAddCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un cours'),
          content: AddCourseForm(
            onAddCourse: (courseName) {
              // Handle the course addition logic directly here
              _fetchCourses(); // Refresh the list of courses after adding a new one
              //Navigator.pop(context); // Close the dialog
            },
          ),
        );
      },
    );
  }

// Function to fetch and display questions for a course
Future<void> _fetchQuestionsForCourse(int courseId) async {
  try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8888/questions/questions/course/$courseId'));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);

      // Display questions in a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Questions for course ID $courseId'),
            content: Column(
              children: [
                for (var questionData in decodedData)
                  ListTile(
                    title: Text(questionData['questionText']),
                    subtitle: Text(questionData['solution']),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to fetch questions. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching questions: $error');
  }
}

  // Function to get courseId from course name
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
    // Fetch the list of courses when the widget is initialized
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cours'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show the Add Course dialog
              _showAddCourseDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Nom du cours')),
            DataColumn(label: Text('')),
          ],
          rows: courseNames.map((courseName) {
            return DataRow(cells: [
              DataCell(
                InkWell(
                  child: Text(courseName),
                  onTap: () async {
                    // Fetch courseId from course name
                    int? courseId = await getCourseIdFromName(courseName);

                    if (courseId != null) {
                      // Fetch and display questions for the selected course
                      _fetchQuestionsForCourse(courseId);
                    } else {
                      print('Failed to get courseId for $courseName');
                    }
                  },
                ),
              ),
              DataCell(IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement logic for editing the course
                },
              )),
            ]);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the Add Course dialog
          _showAddCourseDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
