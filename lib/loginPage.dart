import 'package:flutter/material.dart';
import 'package:projetmobiles6/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/test.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _goToSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => SignInPage()
        ),
            (route) => false
    );
  }

  void _goToTest() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ParametreSignIn()
        ),
            (route) => false
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox (
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 2.05,
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
                  height: MediaQuery.of(context).size.width / 24,
                ),
                const Center(
                    child: Text("Bienvenue sur \n Done&Gone", style: TextStyle(fontSize: 25),)
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: TextField(
                      controller: login,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
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
                  height: MediaQuery.of(context).size.width / 30,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
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
                  height: MediaQuery.of(context).size.width / 30,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _auth.signInWithEmailAndPassword(email: login.text
                              .trim(), password: password.text.trim());
                          print("test");
                          _goToTest();
                        //  Naviguer à la page des projets
                        } on FirebaseAuthException catch  (e)  {
                          print(e);
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
                  height: MediaQuery.of(context).size.width / 20,
                ),
                Divider(color: Colors.black, height: 1),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 30,
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
