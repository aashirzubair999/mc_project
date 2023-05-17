import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:project_final/Screens/signin_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/colors_utils.dart';
class SignUp_screen extends StatefulWidget {
  const SignUp_screen({Key? key}) : super(key: key);

  @override
  State<SignUp_screen> createState() => _SignUp_screenState();
}

class _SignUp_screenState extends State<SignUp_screen> {
  TextEditingController _passwordTextController=TextEditingController();
  TextEditingController _userTextController=TextEditingController();
  TextEditingController _emailTextController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("SignUp",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [
              Colors.greenAccent,
              Colors.lightBlueAccent,
              Colors.greenAccent
            ],begin: Alignment.center, end: Alignment.bottomCenter
            )),
            child: SingleChildScrollView(child: Padding(padding:EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height *0.2, 20, 0) ,

                child:Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child:
                  Column(
                    children:<Widget> [

                      const SizedBox(height: 20),
                      reusableTextField("Enter UserName", Icons.person_outlined, false, _userTextController),
                      const SizedBox(height: 20),
                      reusableTextField("Enter Email", Icons.person_outlined, false, _emailTextController),
                      const  SizedBox(height: 20),
                      reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                      firebaseUIButton(context, "Sign Up", () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                            .then((value) {
                          showSnackBar(context, "SignUp successful!");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>SigninScreen()));
                        }).onError((error, stackTrace) {
                          print(error.toString());
                          var errorMessage = error.toString();
                          var actualerror1= errorMessage.length;
                          var actualerror= errorMessage.substring(30, actualerror1);
                          showSnackBar(context, actualerror );
                        });
                      })
                    ],
                  ),
                )
            ),
            )));
  }
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
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
}