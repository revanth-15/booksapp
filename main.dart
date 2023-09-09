import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  final TextEditingController emailController = TextEditingController();

  Future fetchDataAndStore(String email) async {
    final response = await http.post(
      Uri.parse('https://notaryapp-staging.herokuapp.com/customer/login'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('apiResponse', jsonEncode(responseData));
      Navigator.pushReplacementNamed(context, '/expenses');
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                await fetchDataAndStore(email);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
