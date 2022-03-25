import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/MainElementItem.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:projetmobiles6/model/ToDo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class projetOrToDo extends StatefulWidget{
  @override
  State<projetOrToDo> createState() => _projetOrToDoState();

}


class _projetOrToDoState extends State<projetOrToDo>{
  bool isSearching = false;
  List<MainElementItem> allMainElementItem = <MainElementItem>[];
  List<MainElementItem> researchMainElementItem = <MainElementItem>[];
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController elementName = TextEditingController();
  final TextEditingController elementDesc = TextEditingController();

  @override
  void initState() {

    fillList();

  }

  void addProject(String name, String description){
    try {
      List<String> member = <String>[];
      member.add(auth.currentUser.uid);
      FirebaseFirestore.instance.collection("project").add(
          {
            'name': name,
            'description' : description,
            'members' : member
          }
      );
    } catch(error){
      print(error);
    }
    fillList();
  }

  void addToDo(String name, String description){
    try {
      FirebaseFirestore.instance.collection("todo").add(
          {
            'name': name,
            'description' : description,
            'member' : auth.currentUser.uid
          }
      );
    } catch(error){
      print(error);
    }
    fillList();
  }

  void research(String search){
    researchMainElementItem = [];
    allMainElementItem.forEach((element) {
      if(element.name.contains(search)){
        researchMainElementItem.add(element);
      }
    });
    setState(() {
    });
  }

  void stopResearch(){
    setState(() {
      researchMainElementItem = allMainElementItem;
    });

  }

  void fillList() async {

    print("filling");
    allMainElementItem = [];
    try{
      await FirebaseFirestore.instance.collection('project').where("members",arrayContains: auth.currentUser.uid.toString()).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {

          allMainElementItem.add(Project(result.get("name"), result.get("description")));
          print("done filling1");
        });
      });

      await FirebaseFirestore.instance.collection('todo').where("member", isEqualTo: auth.currentUser.uid.toString()).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.data().values);
          allMainElementItem.add(ToDo(result.get("name"), result.get("description")));
          print("done filling2");
        });
      });

    }catch(error){
      print("error : ");
      print(error);
    }

    setState(() {
      print("reset affichage");
      researchMainElementItem = allMainElementItem;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !isSearching ? const Text('Rechercher') :
          TextField(decoration: const InputDecoration(icon: Icon(Icons.search),
              hintText: "Chercher ici"),
            onChanged: research,),
          backgroundColor: const Color(0xFFD8D2ED),
          actions: [
            isSearching ?
            Padding(
                padding: EdgeInsets.only(right: 1),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  child: const Icon(
                    Icons.cancel,
                    size: 26.0,
                  ),
                )
            ) :
            Padding(
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
                )
            ),
            const VerticalDivider(),
            Padding(
                padding: const EdgeInsets.only(left : 4, right: 10),
                child: GestureDetector(
                  onTap: () {
                    //  ToDo make a route to user settings
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )
            ),
          ]
      ),
      body :
      researchMainElementItem.isEmpty ?
      const Center(
          child : Text("PAS DE PROJET EN COURS")
      ) : ListView.builder(
          itemCount: researchMainElementItem.length,
          itemBuilder: (context, i) {
            return Container(
                margin: i == 0 ? const EdgeInsets.only(top: 10,bottom: 4,left: 4,right: 4) : const EdgeInsets.all(4.0),
                decoration: BoxDecoration (
                    color: researchMainElementItem.elementAt(i) is Project ? const Color(0xFFFFDDB6) : const Color(0xFFFFC6C6),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black,
                    //     spreadRadius: 0,
                    //     blurRadius: 0,
                    //     offset: Offset(0, 2),
                    //   )
                    // ],
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  title: Text(researchMainElementItem.elementAt(i).name),
                  subtitle: Text(researchMainElementItem.elementAt(i).description),
                )
            );

          }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalCreateProjectOrTasks(context);
        },
        backgroundColor: Color(0xFF92DEB1),
        child: const Icon(Icons.add),
      ),

    );
  }

  _showModalCreateProjectOrTasks(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("Création",
                        style: TextStyle(color: Color(0xFF696868), fontSize: 25)),
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xFF92DEB1),
                    bottom: const TabBar(
                      indicatorColor: Colors.white,
                      tabs: [
                        Text(
                          "Projet",
                          style:
                          TextStyle(color: Color(0xFF696868), fontSize: 20),
                        ),
                        Text(
                          "Liste ToDo",
                          style:
                          TextStyle(color: Color(0xFF696868), fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Container(
                        child:
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child:


                          Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 25,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: TextField(
                                    controller: elementName,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: "Nom du projet",
                                      fillColor: Colors.white70,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 20,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: TextField(
                                    controller: elementDesc,
                                    maxLines: 10,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: "Description du projet",
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
                                    if(!(elementName.text.isEmpty && elementDesc.text.isEmpty)){
                                      addProject(elementName.text.trim(), elementDesc.text.trim());
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
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextField(
                                controller: elementName,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Nom de la liste ToDo",
                                  fillColor: Colors.white70,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextField(
                                controller: elementDesc,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Description de la liste ToDo",
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
                                if(!(elementName.text.isEmpty && elementDesc.text.isEmpty)){
                                  addToDo(elementName.text.trim(), elementDesc.text.trim());
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
                    ],
                  ),
                ),
              ),
            ),

          );
        });
  }


}