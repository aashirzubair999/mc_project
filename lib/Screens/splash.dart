import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_final/Screens/signin_screen.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds and then move to the next screen
    Timer(Duration(seconds: 3), () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SigninScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   Color(0xFF1D7151),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/actualsplash.png'),
          ),
          Padding(padding: EdgeInsets.all(20)),
         ],


      ),
    );
  }
}