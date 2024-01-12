import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autoecoleproject/login.dart'; // Import your login screen file

class Dashboard extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    print('Logging out...'); // Add this line

    // Clear any authentication state (example using shared preferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    print('Navigating back to login screen...'); // Add this line

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false, // Clear the navigation stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AutoEcole'),
        actions: [
          _buildNavItem('Cours', () {
            // Navigate to Cours screen
            Navigator.pushNamed(context, '/cours');
          }, context),
          _buildNavItem('Users', () {
            // Navigate to Client screen
            Navigator.pushNamed(context, '/users');
          }, context),
          _buildNavItem('Q&A', () {
            // Navigate to Quiz screen
            Navigator.pushNamed(context, '/Q&A');
          }, context),
          _buildNavItem('Sign Out', () {
            // Handle Sign Out button press
            logout(context);
          }, context),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onPressed, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
