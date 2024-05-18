import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration (seconds:5) , () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=>MyHomePage(title: '',))
      );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(

        color: Colors.green,

        child: Center(
            child:Text("ContactEase",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w700,
      color: Colors.white
      ),),
        ),

      ),


    );



  }
}