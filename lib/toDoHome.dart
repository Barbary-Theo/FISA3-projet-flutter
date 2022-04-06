import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Categorie.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

import 'model/Task.dart';

class toDoHome extends StatefulWidget {
  final String mainElementId;

  const toDoHome({Key key, this.mainElementId}) : super(key: key);

  @override
  State<toDoHome> createState() =>
      _toDoHomeState(mainElementId: mainElementId);
}

class _toDoHomeState extends State<toDoHome> {
  bool isSearching = false;
  final String mainElementId;
  final TextEditingController tacheName = TextEditingController();
  List<Task> allTache = <Task>[];
  List<Task> researchTache = <Task>[];
  String errorText = "";
  bool loading = true;

  List<Color> colorList = [
    Color(0xFFD7F2D3),
    Color(0xFFD8D2ED),
    Color(0xFFFFC6C6),
    Color(0xFFFFDDB6),
  ];

  _toDoHomeState({this.mainElementId});

  List<Widget> posiList = <Widget>[];
  Widget allTaskWidget;

  List<List<double>> allCoordinate = [];

  void setAllPositionned() {
    posiList = [];

    for(int i = 0 ; i < allTache.length ; i++) {

      if(allCoordinate.length < allTache.length) {
        allCoordinate.add([allTache.elementAt(i).x, allTache.elementAt(i).y]);
      }

      posiList.add(
          Positioned(
              top: allCoordinate.elementAt(i)[1],
              left: allCoordinate.elementAt(i)[0],
              child: GestureDetector(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Card(
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: const Color(0xFFFFDDB6),
                        child: Stack(
                           children: [
                              Center(child: Text(allTache.elementAt(i).name.toString())),
                              Checkbox(
                                checkColor: Colors.white,
                                value: allTache.elementAt(i).validate,
                                onChanged: (bool value) {
                                  setState(() {
                                    print("to change detected");
                                  });
                                },
                              ),
                            ],
                        )
                      )
                  ),
                  onVerticalDragEnd: (DragEndDetails dd){
                    FirebaseFirestore.instance.collection("task").where(
                        "mainElementId", isEqualTo: mainElementId).where("name", isEqualTo: allTache.elementAt(i).name).get().then((querySnapshot) {
                      querySnapshot.docs.forEach((result) {
                        Map mapX = <String, double>{};
                        Map mapY = <String, double>{};
                        mapX.putIfAbsent("x", () => allCoordinate.elementAt(i)[0]);
                        mapY.putIfAbsent("y", () => allCoordinate.elementAt(i)[1]);
                        FirebaseFirestore.instance.collection("task")
                            .doc(result.id).update(mapX);
                        FirebaseFirestore.instance.collection("task")
                            .doc(result.id).update(mapY);
                      });
                    });
                  },
                  onVerticalDragUpdate: (DragUpdateDetails dd) {
                    setState(() {
                      print(dd);
                      allCoordinate.elementAt(i)[1] = dd.globalPosition.dy - MediaQuery.of(context).size.height / 6;
                      allCoordinate.elementAt(i)[0] = dd.globalPosition.dx - MediaQuery.of(context).size.width / 6;
                      displayTask();
                    });
                  },
              )
          ),
      );
    }
  }

  displayTask () {
    setAllPositionned();
    allTaskWidget =  Stack(
      children: posiList,
    );
  }

  @override
  void initState() {
    fillList();
  }

  void research(String search) {
    researchTache = [];
    allTache.forEach((element) {
      if (element.name.contains(search)) {
        researchTache.add(element);
      }
    });

    setState(() {});
  }

  void addTache(String name) {
    try {
      FirebaseFirestore.instance
          .collection("task")
          .add({'name': name, 'mainElementId': mainElementId, 'x': 0.0, 'y': 0.0, 'validate': false});
    } catch (error) {
      print(error);
    }
    fillList();
  }

  Future<void> fillList() async {
    allTache = [];
    try {
      var rng = Random();
      await FirebaseFirestore.instance
          .collection('task')
          .where("mainElementId", isEqualTo: mainElementId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          allTache.add(Task(result.get("name"), 0, result.get("x"), result.get("y"), result.get("mainElementId"), result.get("validate")));
        });
      });
      await displayTask();
    } catch (error) {
      print(error);
    }

    setState(() {
      researchTache = allTache;
      print(loading);
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !isSearching
              ? const Text('Rechercher')
              : TextField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.search), hintText: "Chercher ici"),
                  onChanged: research,
                ),
          backgroundColor: const Color(0xFFD8D2ED),
          actions: [
            isSearching
                ? Padding(
                    padding: EdgeInsets.only(right: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          researchTache = allTache;
                          isSearching = !isSearching;
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        size: 26.0,
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.only(right: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      child: const Icon(
                        Icons.search,
                        size: 26.0,
                      ),
                    )),
          ]),
      body: loading
          ? const Center(
              child: SpinKitChasingDots(
                color: Color(0xFFFFDDB6),
                size: 50.0,
              ),
            )
          : researchTache.isEmpty
              ? const Center(child: Text("Aucune tâche dans cette ToDo List"))
              : allTaskWidget,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          _showModalCreateCategorie(context);
          errorText = "";
        },
        backgroundColor: const Color(0xFF92DEB1),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showModalCreateCategorie(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Création",
                      style: TextStyle(color: Color(0xFF696868), fontSize: 25)),
                  automaticallyImplyLeading: false,
                  backgroundColor: Color(0xFF92DEB1),
                ),
                body: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextField(
                            controller: tacheName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Nom de la tâche",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFFFDDB6)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            print(tacheName.text);
                            if (!tacheName.text.isEmpty) {
                              addTache(
                                  tacheName.text.toString().trim());
                            }
                            Navigator.pop(context, false);
                          },
                          child: const Text(
                            'Valider',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
