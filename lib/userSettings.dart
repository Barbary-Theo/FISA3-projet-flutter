import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class userSettings extends StatelessWidget{

  final TextEditingController login = TextEditingController();
  final TextEditingController mdp1 = TextEditingController();
  final TextEditingController mdp2 = TextEditingController();
  final TextEditingController mdp3 = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String userName = "";

  @override
  void initState() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    await _auth;
    userName = _auth.currentUser.displayName;
    print(userName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1),
              child: IconButton(
                alignment: Alignment.topLeft,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => projetOrToDo()
                        ),
                            (route) => false
                    );
                  },
                  icon: const Icon(
                      Icons.keyboard_return
                  )
              ),
            ),
            Column(
              children : [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFDBBFFF),
                        child: Text(userName.toString()),
                      ),
                      Text(userName),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

}