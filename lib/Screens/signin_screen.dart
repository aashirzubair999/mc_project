import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_final/Screens/camera.dart';
import 'package:project_final/Screens/reset_password.dart';
import 'package:project_final/Screens/signup_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/colors_utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              Colors.lightBlueAccent,
              Colors.greenAccent
            ],
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 90,
                  backgroundImage: AssetImage('assets/images/login.png'),
                  backgroundColor: Colors.white60,
                ),

                const SizedBox(height: 30),
                reusableTextField("Enter Email", Icons.person_outlined, false, _emailTextController,),
                const SizedBox(height: 15),
                reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                SizedBox(height: 20), // Updated SizedBox height to 20
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) {
                        showSnackBar(context, "Login successful!");

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cameraAccess()),
                        );
                      }).onError((error, stackTrace) {
                        showSnackBar(context, "Login failed. Please try again.");
                      });
                    },
                    child: Text("Sign In",style: TextStyle(fontSize: 16),),
                  ),
                ),
                const SizedBox(height: 15),
                forgotPassword(context),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_screen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {
            // Do something
          },
        ),
      ),
    );
  }

  Widget forgotPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.blueAccent),
          textAlign: TextAlign.center,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
