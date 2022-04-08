import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/MainElementItem.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:projetmobiles6/model/ToDo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/projectMain.dart';
import 'package:projetmobiles6/toDoMain.dart';
import 'package:projetmobiles6/userSettings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class projet extends StatefulWidget {
  @override
  State<projet> createState() => _projetState();
}

class _projetState extends State<projet> {
  bool isSearching = false;
  List<MainElementItem> allMainElementItem = <MainElementItem>[];
  List<MainElementItem> researchMainElementItem = <MainElementItem>[];
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController elementName = TextEditingController();
  final TextEditingController elementDesc = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    fillList();
  }

  void addProject(String name, String description) {
    try {
      List<String> member = <String>[];
      member.add(auth.currentUser.uid);
      FirebaseFirestore.instance
          .collection("project")
          .add({'name': name, 'description': description, 'members': member});
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    fillList();
  }

  void addToDo(String name, String description) {
    try {
      FirebaseFirestore.instance.collection("todo").add({
        'name': name,
        'description': description,
        'member': auth.currentUser.uid
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    fillList();
  }

  void research(String search) {
    researchMainElementItem = [];
    for (var element in allMainElementItem) {
      if (element.name.contains(search)) {
        researchMainElementItem.add(element);
      }
    }
    setState(() {});
  }

  void fillList() async {
    allMainElementItem = [];
    try {
      await FirebaseFirestore.instance
          .collection('project')
          .where("members", arrayContains: auth.currentUser.uid.toString())
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          allMainElementItem.add(Project(
              result.get("name"), result.get("description"), result.id));
        }
      });

      await FirebaseFirestore.instance
          .collection('todo')
          .where("member", isEqualTo: auth.currentUser.uid.toString())
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          allMainElementItem.add(
              ToDo(result.get("name"), result.get("description"), result.id));
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    setState(() {
      researchMainElementItem = allMainElementItem;
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
                    padding: const EdgeInsets.only(right: 1),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          researchMainElementItem = allMainElementItem;
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
            const VerticalDivider(),
            Padding(
                padding: const EdgeInsets.only(left: 4, right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => userSettings()),
                        (route) => false);
                  },
                  child: const Icon(
                    Icons.settings,
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
          : researchMainElementItem.isEmpty
              ? const Center(child: Text("Pas de projets en cours"))
              : ListView.builder(
                  itemCount: researchMainElementItem.length,
                  itemBuilder: (context, i) {
                    return Card(
                        margin: i == 0
                            ? const EdgeInsets.only(
                                top: 10, bottom: 4, left: 4, right: 4)
                            : const EdgeInsets.all(4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: researchMainElementItem.elementAt(i) is Project
                            ? const Color(0xFFFFDDB6)
                            : const Color(0xFFFFC6C6),
                        shadowColor: Colors.black,
                        elevation: 5,
                        child: ListTile(
                          title:
                              Text(researchMainElementItem.elementAt(i).name),
                          subtitle: Text(
                              researchMainElementItem.elementAt(i).description),
                          onTap: () {
                            researchMainElementItem.elementAt(i) is Project
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => projectMain(
                                            mainElementId:
                                                researchMainElementItem
                                                    .elementAt(i)
                                                    .id)),
                                    (route) => false)
                                : Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => toDoMain(
                                            mainElementId:
                                                researchMainElementItem
                                                    .elementAt(i)
                                                    .id)),
                                    (route) => false);
                          },
                        ));
                  }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalCreateProjectOrTasks(context);
        },
        backgroundColor: const Color(0xFF92DEB1),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showModalCreateProjectOrTasks(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16),
                  )
              ),
              contentPadding: const EdgeInsets.all(5),
              content: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  height: MediaQuery.of(context).size.height / 1.9,
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size(double.infinity, 50),
                        child: AppBar(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0))),
                          automaticallyImplyLeading: false,
                          backgroundColor: const Color(0xFF92DEB1),
                          bottom: const TabBar(
                            indicatorColor: Colors.white,
                            tabs: [
                              Text(
                                "Projet",
                                style: TextStyle(
                                    color: Color(0xFF696868), fontSize: 20),
                              ),
                              Text(
                                "Liste ToDo",
                                style: TextStyle(
                                    color: Color(0xFF696868), fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 25,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 1.5,
                                height:
                                    MediaQuery.of(context).size.height / 15,
                                child: TextField(
                                  controller: elementName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: "Nom du projet",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 20,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 1.5,
                                height:
                                    MediaQuery.of(context).size.height / 5,
                                child: TextField(
                                  controller: elementDesc,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: "Description du projet",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 30,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xFFFFDDB6),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (!(elementName.text.isEmpty &&
                                      elementDesc.text.isEmpty)) {
                                    addProject(elementName.text.trim(),
                                        elementDesc.text.trim());
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
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 25,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 1.5,
                                height:
                                    MediaQuery.of(context).size.height / 15,
                                child: TextField(
                                  controller: elementName,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: "Nom de la liste ToDo",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 20,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 1.5,
                                height:
                                    MediaQuery.of(context).size.height / 5,
                                child: TextField(
                                  controller: elementDesc,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: "Description de la liste ToDo",
                                    fillColor: Colors.white70,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 25,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFFFDDB6)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (!(elementName.text.isEmpty &&
                                      elementDesc.text.isEmpty)) {
                                    addToDo(elementName.text.trim(),
                                        elementDesc.text.trim());
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
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
