import 'package:flutter/material.dart';
import 'package:sih_app/pages/loading.dart';
import 'package:sih_app/pages/moving.dart';
import 'package:sih_app/utils/widgets.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
           onTap: () {
            nextScreenReplace(context, MovingPage());
          },
          child: Container(
            height: 50,
            width: 300,
            color: Colors.red,
            child: Text("get started",style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}