import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
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
                    child: Text("Bienvenu sur \n Done&Gone", style: TextStyle(fontSize: 25),)
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: const TextField(
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
                    child: const TextField(
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
                    onPressed: () {},
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
                      onPressed: () {},
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
