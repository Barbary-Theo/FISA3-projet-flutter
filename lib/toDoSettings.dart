import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/model/Members.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class toDoSettings extends StatefulWidget {
  final String mainElementId;

  const toDoSettings({Key key, this.mainElementId}) : super(key: key);

  @override
  State<toDoSettings> createState() =>
      _toDoSettings(mainElementId: mainElementId);
}

class _toDoSettings extends State<toDoSettings> {
  final String mainElementId;

  _toDoSettings({this.mainElementId});

  String _toDoName = "";
  String _toDoDesc = "";
  final List<Color> _colorList = [
    const Color(0xFFD7F2D3),
    const Color(0xFFD8D2ED),
    const Color(0xFFFFDDB6),
    const Color(0xFFFFDDB6),
  ];

  @override
  void initState() {
    _initializeProjectData();
  }

  Future<void> _initializeProjectData() async {
    try {
      print("recupération data todo");
      print(mainElementId);
      await FirebaseFirestore.instance
          .collection('todo')
          .doc(mainElementId)
          .get()
          .then((querySnapshot) {
        _toDoName = querySnapshot.get("name");
        _toDoDesc = querySnapshot.get("description");
      });
      setState(() {});
    } catch (error) {
      print("error : ");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
        ),
        const Center(
          child: Text(
            "Nom de la ToDo List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        Center(
          child: Text(
            _toDoName,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        const Center(
          child: Text(
            "Description de la ToDo List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        Center(
          child: Text(_toDoDesc),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFFFC6C6)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () {
            _sureToDelete(context);
          },
          child: const Text(
            'Supprimer la ToDo List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
        ),
      ],
    ));
  }

  Future<void> _deleteToDo() async {
    try {
      print(mainElementId);
      await FirebaseFirestore.instance
          .collection("task")
          .where("mainElementId", isEqualTo: mainElementId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.get("name"));
          FirebaseFirestore.instance.collection("task").doc(result.id).delete();
        });
      });

      await FirebaseFirestore.instance
          .collection("todo")
          .doc(mainElementId)
          .delete();

      //Todo : Remove all task link to categorie

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => projetOrToDo()),
          (route) => false);
    } catch (e) {
      print("error : ");
      print(e);
    }
  }

  _sureToDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Confirmation",
                      style: TextStyle(color: Color(0xFF696868), fontSize: 25)),
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF92DEB1),
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFFDDB6)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _deleteToDo();
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Oui',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFFC6C6)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Non',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
