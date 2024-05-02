import 'package:flutter/material.dart';
import 'package:wclone/Controllers/authController.dart';
import 'package:wclone/CustomUI/textFieldCard.dart';
import 'package:wclone/Screens/AuthScreens/SignUpScreen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _username = TextEditingController();
    final TextEditingController _password = TextEditingController();
    return Scaffold(
      body: Container(
        color: Color.fromARGB(66, 0, 47, 98),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome back",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50),
                ),
                SizedBox(
                  height: 100.0,
                ),
                textFieldWidget(
                  maxLines: 1,
                  controller: _username,
                  hintText: "Enter Your Username",
                ),
                textFieldWidget(
                  controller: _password,
                  maxLines: 1,
                  obsecure: true,
                  hintText: "Password",
                ),
                SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    signIn(context, _username, _password);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Text(
                    "Dont have an Account?",
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
