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

  @override
  void initState() {

    fillList();

  }

  void addProject(String name, String description){
    try {
      FirebaseFirestore.instance.collection("projet").add(
          {
            'name': name,
            'description' : description,
            'member' : auth.currentUser.uid
          }
      );
    } catch(error){
      print(error);
    }

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
  }

  void research(String search){
    researchMainElementItem = [];
    try{
      FirebaseFirestore.instance.collection('project').where("user", isEqualTo: auth.currentUser.uid).where("name", arrayContains: search).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          researchMainElementItem.add(Project(result.data().values.elementAt(0), result.get("description")));
        }
      });

      FirebaseFirestore.instance.collection('todo').where("user", isEqualTo: auth.currentUser.uid).where("name", arrayContains: search).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          researchMainElementItem.add(ToDo(result.data().values.elementAt(0), result.get("description")));
        }
      });
    }catch(error){
      print(error);
    }
    setState(() {

    });
  }

  void stopResearch(){
    setState(() {
      researchMainElementItem = allMainElementItem;
    });

  }

  Future<void> fillList() async {
    allMainElementItem = [];
    try{
      FirebaseFirestore.instance.collection('project').where("user", isEqualTo: auth.currentUser.uid).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          allMainElementItem.add(Project(result.data().values.elementAt(0), result.get("description")));
        }
      });

      FirebaseFirestore.instance.collection('todo').where("user", isEqualTo: auth.currentUser.uid).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          allMainElementItem.add(ToDo(result.data().values.elementAt(0), result.get("description")));
        }
      });
    }catch(error){
      print(error);
    }
    setState(() {
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
              !isSearching ?
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  }
              ) :
              IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      stopResearch();
                      isSearching = !isSearching;
                    });
                  }
              )
            ]
        ),
        body : researchMainElementItem.isEmpty ?
        const Center(
            child : Text("PAS DE PROJET EN COURS")
        )

            : ListView.builder(
            itemCount: researchMainElementItem.length,
            itemBuilder: (context, i) {
              return Container(
                  margin: const EdgeInsets.all(4.0),
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
        )
    );
  }

}