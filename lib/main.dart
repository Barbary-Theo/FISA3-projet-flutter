import 'package:flutter/material.dart';
import 'package:projetmobiles6/projetOrToDo.dart';
import 'loginPage.dart';
import 'signInPage.dart';

int selectedIndex = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: projetOrToDo(),
    );
  }
}
