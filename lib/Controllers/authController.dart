import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wclone/Screens/Homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signUp(
    BuildContext context,
    TextEditingController username,
    TextEditingController gender,
    TextEditingController password,
    TextEditingController Fullname) async {
  final url = Uri.parse('https://vchat-bpx8.onrender.com/auth/signup');
  try {
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username.text,
        'password': password.text,
        "confirmPassword": password.text,
        'fullName': Fullname.text,
        'gender': gender.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final authToken = jsonResponse['authToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', authToken);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Username Already Taken"),
            content: Text("Please choose a different username."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to register user');
      print(response.statusCode);
    }
  } catch (error) {
    print('Error registering user: $error');
  }
}

Future<void> signIn(
  BuildContext context,
  TextEditingController _username,
  TextEditingController _password,
) async {
  final url = Uri.parse("https://vchat-bpx8.onrender.com/auth/login");
  try {
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': _username.text,
        'password': _password.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final authToken = jsonResponse['authToken'];
      final sourceId = jsonResponse['_id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', authToken);
      print(authToken);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('senderId', sourceId);
      print(sourceId);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Username/Password"),
            content: Text("Please Enter correct Username/Password"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to register user');
      print(response.statusCode);
    }
  } catch (error) {
    print('Error registering user: $error');
  }
}
