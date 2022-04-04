import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Categorie.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class toDoHome extends StatefulWidget {
  final String mainElementId;

  const toDoHome({Key key, this.mainElementId}) : super(key: key);

  @override
  State<toDoHome> createState() =>
      _projectHomeState(mainElementId: mainElementId);
}

class _projectHomeState extends State<toDoHome> {
  bool isSearching = false;
  final String mainElementId;
  final TextEditingController categorieName = TextEditingController();
  List<Categorie> allCategorie = <Categorie>[];
  List<Categorie> researchCategorie = <Categorie>[];
  String errorText = "";
  bool loading = true;

  List<Color> colorList = [
    Color(0xFFD7F2D3),
    Color(0xFFD8D2ED),
    Color(0xFFFFC6C6),
    Color(0xFFFFDDB6),
  ];

  _projectHomeState({this.mainElementId});

  @override
  void initState() {
    fillList();
  }

  void research(String search) {
    researchCategorie = [];
    allCategorie.forEach((element) {
      if (element.name.contains(search)) {
        researchCategorie.add(element);
      }
    });

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
    fillList();
  }

  Future<void> fillList() async {
    allCategorie = [];
    try {
      await FirebaseFirestore.instance
          .collection('categorie')
          .where("project", isEqualTo: mainElementId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          allCategorie.add(Categorie([], result.get("name")));
        });
      });
    } catch (error) {
      print("error : ");
      print(error);
    }

    setState(() {
      researchCategorie = allCategorie;
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
          : researchCategorie.isEmpty
              ? const Center(child: Text("Pas de tâches dans la toDo List."))
              : ListView.builder(
                  itemCount: researchCategorie.length,
                  itemBuilder: (context, i) {
                    return Container(
                        margin: i == 0
                            ? const EdgeInsets.only(
                                top: 10, bottom: 4, left: 4, right: 4)
                            : const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: colorList[i % 4],
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black,
                            //     spreadRadius: 0,
                            //     blurRadius: 0,
                            //     offset: Offset(0, 2),
                            //   )
                            // ],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          title: Text(researchCategorie.elementAt(i).name),
                          onTap: () {
                            //  todo add action when categorie is pressed
                          },
                        ));
                  }),
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
                                Color(0xFFFFDDB6)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            print(categorieName.text);
                            if (!categorieName.text.isEmpty) {
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
            ),
          );
        });
  }
}
