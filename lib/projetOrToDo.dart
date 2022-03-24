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
            title: !isSearching ? Text('Rechercher') :
            TextField(decoration: InputDecoration(icon: Icon(Icons.search),
                hintText: "Cherchez ici"),
              onChanged: research,),
            backgroundColor: const Color(0xFFD8D2ED),
            actions: [
              !isSearching ?
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = !this.isSearching;
                    });
                    // (context as Element).markNeedsBuild();
                  }
              ) :
              IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      stopResearch();
                      this.isSearching = !this.isSearching;
                      // (context as Element).markNeedsBuild();
                    });
                  }
              )
            ]
        ),
        body : researchMainElementItem.length == 0 ?
            Center(
              child : Container(
                  child: Text("PAS DE PROJET EN COURS"),
                )
            )

            : ListView.builder(
            itemCount: researchMainElementItem.length,
            itemBuilder: (context, i) {
              return Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: new BoxDecoration (
                      color: researchMainElementItem.elementAt(i) is Project ? Color(0xFFFFDDB6) : Color(0xFFFFC6C6),
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