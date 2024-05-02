import 'package:flutter/material.dart';
import 'package:wclone/Screens/AuthScreens/SignUpScreen.dart';
import 'package:wclone/Screens/CameraScreen.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wclone/Screens/Homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken');
  runApp(MyApp(authToken: authToken));
}

class MyApp extends StatelessWidget {
  final String? authToken; // Pass authToken from main()

  MyApp({this.authToken});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "OpenSans"),
      home: authToken != null ? HomeScreen() : SignUpScreen(),
    );
  }
}
