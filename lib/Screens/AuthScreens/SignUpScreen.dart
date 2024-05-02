import 'package:flutter/material.dart';
import 'package:wclone/Controllers/authController.dart';
import 'package:wclone/CustomUI/textFieldCard.dart';
import 'package:wclone/Screens/AuthScreens/SignInScreen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _username = TextEditingController();
    final TextEditingController _name = TextEditingController();
    final TextEditingController _gender = TextEditingController();
    final TextEditingController _password = TextEditingController();

    return Scaffold(
      body: Container(
        color: Color.fromARGB(66, 0, 47, 98),
        height: MediaQuery.sizeOf(context).height * 1,
        width: MediaQuery.sizeOf(context).width * 1,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome, SignUp Now",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50),
                ),
                SizedBox(
                  height: 100,
                ),
                textFieldWidget(
                  maxLines: 1,
                  hintText: "Username",
                  controller: _username,
                ),
                textFieldWidget(
                  maxLines: 1,
                  hintText: "Full Name",
                  controller: _name,
                ),
                textFieldWidget(
                  maxLines: 1,
                  hintText: "Gender",
                  controller: _gender,
                ),
                textFieldWidget(
                  maxLines: 1,
                  hintText: "Password",
                  controller: _password,
                  obsecure: true,
                ),
                SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signUp(context, _username, _gender, _password, _name);
                  },
                  child: Text(
                    "Sgin Up",
                    style: TextStyle(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
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
