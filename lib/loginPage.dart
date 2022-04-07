import 'package:flutter/material.dart';
import 'package:projetmobiles6/projetOrToDo.dart';
import 'package:projetmobiles6/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String errorText = "";

  void _goToSignIn() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SignInPage(),
      ),
    );
  }

  void _goToProjectOrToDo() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => projetOrToDo()
        ),
            (route) => false
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox (
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 2,
          child: Card(
            shadowColor: Colors.black,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: const Color(0xFFFFDDB6),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                const Center(
                    child: Text("Bienvenue sur \n Done&Gone", style: TextStyle(fontSize: 25),)
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 15,
                    child: TextField(
                      controller: login,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintText: "Identifiant",
                          fillColor: Color(0xFFFCFCFC)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 70,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 15,
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          filled: true,
                          hintText: "Mot de passe",
                          fillColor: Color(0xFFFCFCFC)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 70,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _auth.signInWithEmailAndPassword(email: login.text.trim(), password: password.text.trim());

                          bool exist = false;

                          await FirebaseFirestore.instance.collection('user').where("id",isEqualTo: _auth.currentUser.uid).get().then((querySnapshot) {
                            querySnapshot.docs.forEach((result) {
                              print(result.get("email"));
                              exist = true;
                              print("already exist");
                            });
                          });

                          print("???");
                          if(!exist) {
                            print("on ajoute");
                            FirebaseFirestore.instance.collection("user").add(
                                {
                                  'email': login.text.trim(),
                                  'id': _auth.currentUser.uid.trim(),
                                }
                            );
                          }
                          _goToProjectOrToDo();
                          //  Naviguer à la page des projets
                        } on FirebaseAuthException catch (e)  {
                          setState(() {
                            errorText = e.message;
                          });
                        }
                      },
                      child: const Text('Se connecter', style: TextStyle(color: Colors.black),),
                      style: ButtonStyle(
                        backgroundColor:  MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 70,
                ),
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                ),
                Divider(color: Colors.black, height: 1),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _goToSignIn();
                        });
                      },
                      child: const Text("S'inscrire", style: TextStyle(color: Colors.black),),
                      style: ButtonStyle(
                        backgroundColor:  MaterialStateProperty.all<Color>(Color (0xFFD8D2ED)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      )
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
