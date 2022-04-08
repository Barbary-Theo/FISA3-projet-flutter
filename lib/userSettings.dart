import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/loginPage.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class userSettings extends StatefulWidget {
  @override
  State<userSettings> createState() => _userSettingsState();
}

class _userSettingsState extends State<userSettings> {
  final TextEditingController mdp1 = TextEditingController();
  final TextEditingController mdp2 = TextEditingController();
  final TextEditingController mdp3 = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String userName = "UserName";
  String errorText = "";

  @override
  void initState() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    _auth;
    setState(() {
      userName = _auth.currentUser.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        body: ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              alignment: Alignment.topLeft,
              constraints: const BoxConstraints(minHeight: 1, minWidth: 1),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => projet()),
                    (route) => false);
              },
              icon: const Icon(Icons.keyboard_backspace)),
        ),
        Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFDBBFFF),
                    radius: MediaQuery.of(context).size.height >
                            MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width / 10
                        : MediaQuery.of(context).size.height / 10,
                    child: Text(userName.characters
                        .characterAt(0)
                        .toUpperCase()
                        .toString()),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  const Divider(color: Colors.black, height: 1),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  const Text(
                    "Pour changer votre mot de passe \n écrivez votre ancien mot de passe \n et n'oubliez pas de le confirmer 🥵.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 15,
                    child: TextField(
                      controller: mdp1,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Ancien mot de passe",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 15,
                    child: TextField(
                      controller: mdp2,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Nouveau mot de passe",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 15,
                    child: TextField(
                      controller: mdp3,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Confirmer le mot de passe",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  Text(
                    errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 80,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF92DEB1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (mdp1.text.isEmpty ||
                          mdp2.text.isEmpty ||
                          mdp3.text.isEmpty) {
                        setState(() {
                          errorText = "Veuillez renseigner tous les champs";
                        });
                      } else {
                        if (mdp2.text == mdp3.text) {
                          try {
                            _auth.currentUser.updatePassword(mdp2.text.trim());
                            setState(() {
                              errorText = "Mot de passe changer !";
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              errorText = e.message;
                            });
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Changer le mot de passe',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Se déconnecter",
                          style: const TextStyle(color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              try {
                                _auth.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            })),
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }
}
