import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCourseForm extends StatefulWidget {
  final Function(String) onAddCourse;

  const AddCourseForm({Key? key, required this.onAddCourse}) : super(key: key);

  @override
  _AddCourseFormState createState() => _AddCourseFormState();
}

class _AddCourseFormState extends State<AddCourseForm> {
  TextEditingController _courseNameController = TextEditingController();

  Future<void> _addCourse(String courseName) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8888/courses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'courseName': courseName}),
      );

      if (response.statusCode == 200) {
        // Course added successfully
        widget.onAddCourse(courseName);

        // Clear the text field
        _courseNameController.clear();

        // Close the Add Course dialog
        Navigator.pop(context);

      } else {
        // Handle the error
        print('Failed to add course. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any network or server error
      print('Error adding course: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _courseNameController,
          decoration: InputDecoration(labelText: 'Nom du cours'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Get the course name from the text field
            String courseName = _courseNameController.text.trim();

            // Check if the course name is not empty
            if (courseName.isNotEmpty) {
              // Call the callback to add the course
              _addCourse(courseName);
            }
          },
          child: Text('Enregistrer'),
        ),
      ],
    );
  }
}
