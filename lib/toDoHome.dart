import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Categorie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'model/Task.dart';

class toDoHome extends StatefulWidget {
  final String mainElementId;

  const toDoHome({Key key, this.mainElementId}) : super(key: key);

  @override
  State<toDoHome> createState() => _toDoHomeState(mainElementId: mainElementId);
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
    const Color(0xFFD7F2D3),
    const Color(0xFFD8D2ED),
    const Color(0xFFFFC6C6),
    const Color(0xFFFFDDB6),
  ];

  _toDoHomeState({this.mainElementId});

  List<Widget> posiList = <Widget>[];
  List<Color> allColor = <Color>[];
  Widget allTaskWidget;

  List<List<double>> allCoordinate = [];

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }

  void setAllPositionned() {
    posiList = [];

    for (int i = 0; i < allTache.length; i++) {
      if (allCoordinate.length < allTache.length) {
        allCoordinate.add([allTache.elementAt(i).x, allTache.elementAt(i).y]);

        if (allTache.elementAt(i).validate) {
          allColor.add(new Color(0xFFD7F2D3));
        } else {
          allColor.add(new Color(0xFFFFDDB6));
        }
      }

      posiList.add(
        Positioned(
            top: allCoordinate.elementAt(i)[1],
            left: allCoordinate.elementAt(i)[0],
            child: GestureDetector(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Card(
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: allColor.elementAt(i),
                      child: Stack(
                        children: [
                          Center(
                              child:
                              Text(allTache.elementAt(i).name.toString())),
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                            MaterialStateProperty.resolveWith(getColor),
                            value: allTache.elementAt(i).validate,
                            onChanged: (bool value) {
                              allTache.elementAt(i).validate = value;
                              if (value) {
                                allColor[i] = new Color(0xFFD7F2D3);
                              } else {
                                allColor[i] = new Color(0xFFFFDDB6);
                              }

                              setState(() {
                                FirebaseFirestore.instance
                                    .collection("task")
                                    .where("mainElementId",
                                    isEqualTo: mainElementId)
                                    .where("name",
                                    isEqualTo: allTache.elementAt(i).name)
                                    .get()
                                    .then((querySnapshot) {
                                  querySnapshot.docs.forEach((result) {
                                    Map mapCheck = <String, bool>{};
                                    mapCheck.putIfAbsent("validate",
                                            () => allTache.elementAt(i).validate);
                                    FirebaseFirestore.instance
                                        .collection("task")
                                        .doc(result.id)
                                        .update(mapCheck);
                                  });
                                });
                                displayTask();
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                alignment: Alignment.topRight,
                                constraints: const BoxConstraints(
                                    minHeight: 1, minWidth: 1),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("task")
                                      .where("mainElementId",
                                      isEqualTo: mainElementId)
                                      .where("name",
                                      isEqualTo: allTache.elementAt(i).name)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((result) {
                                      FirebaseFirestore.instance
                                          .collection("task")
                                          .doc(result.id)
                                          .delete();
                                    });
                                    fillList();
                                    displayTask();
                                  });
                                },
                                icon: const Icon(
                                  Icons.highlight_remove_rounded,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ))),
              onVerticalDragEnd: (DragEndDetails dd) {
                FirebaseFirestore.instance
                    .collection("task")
                    .where("mainElementId", isEqualTo: mainElementId)
                    .where("name", isEqualTo: allTache.elementAt(i).name)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((result) {
                    Map mapX = <String, double>{};
                    Map mapY = <String, double>{};
                    mapX.putIfAbsent("x", () => allCoordinate.elementAt(i)[0]);
                    mapY.putIfAbsent("y", () => allCoordinate.elementAt(i)[1]);
                    FirebaseFirestore.instance
                        .collection("task")
                        .doc(result.id)
                        .update(mapX);
                    FirebaseFirestore.instance
                        .collection("task")
                        .doc(result.id)
                        .update(mapY);
                  });
                });
              },
              onVerticalDragUpdate: (DragUpdateDetails dd) {
                setState(() {
                  allCoordinate.elementAt(i)[1] = dd.globalPosition.dy -
                      MediaQuery.of(context).size.height / 6;
                  allCoordinate.elementAt(i)[0] = dd.globalPosition.dx -
                      MediaQuery.of(context).size.width / 6;
                  displayTask();
                });
              },
            )),
      );
    }
  }

  displayTask() {
    setAllPositionned();
    allTaskWidget = Stack(
      children: posiList,
    );
  }

  @override
  void initState() {
    fillList();
  }

  void addTache(String name) {
    try {
      FirebaseFirestore.instance.collection("task").add({
        'name': name,
        'mainElementId': mainElementId,
        'x': 0.0,
        'y': 0.0,
        'validate': false
      });
    } catch (error) {
      print(error);
    }
    fillList();
  }

  Future<void> fillList() async {
    allTache = [];
    allCoordinate = [];
    allColor = [];
    try {
      var rng = Random();
      await FirebaseFirestore.instance
          .collection('task')
          .where("mainElementId", isEqualTo: mainElementId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          allTache.add(Task(
              result.get("name"),
              0,
              result.get("x"),
              result.get("y"),
              result.get("mainElementId"),
              result.get("validate")));
        });
      });
      await displayTask();
    } catch (error) {
      print(error);
    }

    setState(() {
      researchTache = allTache;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8D2ED),
      ),
      body: researchTache.isEmpty
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: tacheName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Nom de la tâche",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF92DEB1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0)),
                      ),
                      child: TextButton(
                        child: Text(
                          "Ajouter la tâche",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          print(tacheName.text);
                          if (!tacheName.text.isEmpty) {
                            addTache(tacheName.text.toString().trim());
                          }
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
