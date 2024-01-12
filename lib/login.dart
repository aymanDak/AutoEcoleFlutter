// login.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:autoecoleproject/widget/login_field.dart';
import 'package:autoecoleproject/dashboard.dart';
import 'package:autoecoleproject/pallete.dart';
import 'dart:convert';


class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginStatus = '';

  Future<void> loginUser(String email, String password, BuildContext context) async {
  print('Attempting to login with email: $email and password: $password');

  final response = await http.post(
    Uri.parse('http://127.0.0.1:8888/users/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Successful login
    loginStatus = 'Login successful: ${response.body}';
    print(loginStatus);

    // Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  } else {
    // Handle login failure
    loginStatus = 'Login failed. Status code: ${response.statusCode}';
    print(loginStatus);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Image.asset('assets/images/signin_balls.png'),
              const Text(
                'Sign in.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 20),
              const SizedBox(height: 15),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginUser(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Text(loginStatus),
            ],
          ),
        ),
      ),
    );
  }
}
