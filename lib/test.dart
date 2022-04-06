import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget{
  @override
  State<test> createState() => _ParametreState();

}

class _ParametreState extends State<test>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suggestion"),
        backgroundColor : const Color.fromRGBO(34,139,34,100),),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Ici faire une page de paramètres"),
          ]
      ),
    );
  }

}