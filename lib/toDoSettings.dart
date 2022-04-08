import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    _initializeProjectData();
  }

  Future<void> _initializeProjectData() async {
    try {
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
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
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

      await FirebaseFirestore.instance
          .collection("task")
          .where("mainElementId", isEqualTo: mainElementId)
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          FirebaseFirestore.instance.collection("task").doc(result.id).delete();
        }
      });

      await FirebaseFirestore.instance
          .collection("todo")
          .doc(mainElementId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => projet()),
              (route) => false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _sureToDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                    child: Column(
                      children: [
                        const Text("Confirmation",
                            style:
                            TextStyle(color: Color(0xFF696868), fontSize: 25)),
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
                      ],
                    )),
              ));
        });
  }

}
