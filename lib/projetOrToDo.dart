import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/MainElementItem.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:projetmobiles6/model/ToDo.dart';

class projetOrToDo extends StatefulWidget{
  @override
  State<projetOrToDo> createState() => _projetOrToDoState();

}


class _projetOrToDoState extends State<projetOrToDo>{
  bool isSearching = false;
  List<MainElementItem> allMainElementItem = <MainElementItem>[];
  List<MainElementItem> researchMainElementItem = <MainElementItem>[];
  List<Color> colorList = <Color>[];

  @override
  void initState() {
    fillList();

  }

  void addProject(){

  }

  void addToDo(){

  }

  void research(String search){

  }

  void stopResearch(){
    researchMainElementItem = allMainElementItem;
  }

  void fillList(){
    //  ToDo
    //  Ajouté la récupération de tous les mainElementItem de firebase dans la variable allMainElementItem

    researchMainElementItem = allMainElementItem;
    print(researchMainElementItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: !isSearching ? const Text('Rechercher') :
            TextField(decoration: const InputDecoration(icon: Icon(Icons.search),
                hintText: "Cherchez ici"),
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
                    // (context as Element).markNeedsBuild();
                  }
              ) :
              IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      stopResearch();
                      isSearching = !isSearching;
                      // (context as Element).markNeedsBuild();
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
                  margin: EdgeInsets.all(4.0),
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