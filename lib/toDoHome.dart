import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Categorie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  final TextEditingController categorieName = TextEditingController();
  List<Categorie> allCategorie = <Categorie>[];
  List<Categorie> researchCategorie = <Categorie>[];
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
  Stack allTaskWidget;

  void setAllPositionned() {
    var rng = Random();
    for(int i = 0 ; i < allCategorie.length ; i++) {
      posiList.add(
        Positioned(
          top: rng.nextDouble() * 100,
          left: rng.nextDouble() * 100,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Card(
                shadowColor: Colors.black,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: const Color(0xFFFFDDB6),
                child: Text(allCategorie.elementAt(i).name.toString())
            )
          )
        )
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
  }

  void research(String search) {
    researchCategorie = [];
    for (var element in allCategorie) {
      if (element.name.contains(search)) {
        researchCategorie.add(element);
      }
    }

    setState(() {});
  }

  void addCategorie(String name) {
    try {
      FirebaseFirestore.instance
          .collection("categorie")
          .add({'name': name, 'project': mainElementId});
    } catch (error) {
      print(error);
    }
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
                    padding: const EdgeInsets.only(right: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          researchCategorie = allCategorie;
                          isSearching = !isSearching;
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        size: 26.0,
                      ),
                    ))
                : Padding(
                    padding: const EdgeInsets.only(right: 1),
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
          : researchCategorie.isEmpty
              ? const Center(child: Text("Pas de tâches dans la toDo List."))
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Création",
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextField(
                          controller: categorieName,
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
                              const Color(0xFFFFDDB6)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (categorieName.text.isNotEmpty) {
                            addCategorie(
                                categorieName.text.toString().trim());
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
          );
        });
  }
}
