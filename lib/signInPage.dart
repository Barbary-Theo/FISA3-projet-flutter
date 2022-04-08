import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.7,
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
                  height: MediaQuery.of(context).size.height / 60,
                ),
                const Center(
                  child: Text(
                    "Bienvenue sur \n Done&Gone",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 15,
                  child: TextField(
                    controller: login,
                    decoration: const InputDecoration(
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
                  height: MediaQuery.of(context).size.height / 25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 15,
                  child: TextField(
                    controller: password1,
                    obscureText: true,
                    decoration: const InputDecoration(
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
                  height: MediaQuery.of(context).size.height / 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 15,
                  child: TextField(
                    controller: password2,
                    obscureText: true,
                    decoration: const InputDecoration(
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
                  height: MediaQuery.of(context).size.height / 70,
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
                        _goToLogIn();
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        errorText = e.message;
                      });
                    } catch (error) {
                      if (kDebugMode) {
                        print(error);
                      }
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
                  style: const TextStyle(color: Colors.red),
                ),
                const Divider(color: Colors.black, height: 1),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFFDDB6)),
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
