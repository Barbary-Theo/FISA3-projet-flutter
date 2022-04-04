// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetmobiles6/loginPage.dart';
import 'package:projetmobiles6/main.dart';
import 'package:projetmobiles6/service/Authentificaiton_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget{
  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {

  final TextEditingController login = TextEditingController();
  final TextEditingController password1 = TextEditingController();
  final TextEditingController password2 = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String errorText = "";

  void _goToLogIn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LoginPage()
        ),
            (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Container(
            child: (Card(
              shadowColor: Colors.black,
              elevation: 10,
              color: const Color(0xFFD8D2ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Center(
                  child: Text(
                    "Bienvenue sur \n Done&Gone",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: TextField(
                    controller: login,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Identifiant",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: TextField(
                    controller: password1,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Mot de passe",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: TextField(
                    controller: password2,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Mot de passe",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await _auth.createUserWithEmailAndPassword(
                          email: login.text.trim(),
                          password: password1.text.trim());
                      setState(() {
                        // errorText = "Vous êtes bien inscrit";
                        _goToLogIn();
                      });

                    } on FirebaseAuthException catch (e)  {
                      setState(() {
                        errorText = e.message;
                      });
                    }
                  },
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                ),
                Divider(color: Colors.black, height: 1),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFFFDDB6)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _goToLogIn();
                  },
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ]),
            )),
          ),
        ),
      ),
    );
  }
}
