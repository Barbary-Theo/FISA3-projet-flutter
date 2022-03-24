import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/MainElementItem.dart';
import 'package:projetmobiles6/model/Project.dart';
import 'package:projetmobiles6/model/ToDo.dart';

class projetOrToDo extends StatefulWidget {
  @override
  State<projetOrToDo> createState() => _projetOrToDoState();
}

class _projetOrToDoState extends State<projetOrToDo> {
  bool isSearching = false;
  List<MainElementItem> allMainElementItem = <MainElementItem>[];
  List<MainElementItem> researchMainElementItem = <MainElementItem>[];
  List<Color> colorList = <Color>[];

  @override
  void initState() {
    fillList();
  }

  void addProjetOrToDo() {}

  void research(String search) {}

  void stopResearch() {
    researchMainElementItem = allMainElementItem;
  }

  void fillList() {
    //  ToDo
    //  Ajouté la récupération de tous les mainElementItem de firebase dans la variable allMainElementItem

    researchMainElementItem = allMainElementItem;
    print(researchMainElementItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !isSearching
              ? Text('Rechercher')
              : TextField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.search), hintText: "Cherchez ici"),
                  onChanged: research,
                ),
          backgroundColor: const Color(0xFFD8D2ED),
          actions: [
            !isSearching
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = !this.isSearching;
                      });
                      // (context as Element).markNeedsBuild();
                    })
                : IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        stopResearch();
                        this.isSearching = !this.isSearching;
                        // (context as Element).markNeedsBuild();
                      });
                    })
          ]),
      body: researchMainElementItem.length == 0
          ? Center(
              child: Container(
              child: Text("PAS DE PROJET EN COURS"),
            ))
          : ListView.builder(
              itemCount: researchMainElementItem.length,
              itemBuilder: (context, i) {
                return Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                        color: researchMainElementItem.elementAt(i) is Project
                            ? Color(0xFFFFDDB6)
                            : Color(0xFFFFC6C6),
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
                      title: Text(researchMainElementItem.elementAt(i).name),
                      subtitle: Text(
                          researchMainElementItem.elementAt(i).description),
                    ));
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalCreateProjectOrTasks(context);
        },
        backgroundColor: Color(0xFF92DEB1),
        child: const Icon(Icons.add),
      ),
    );
  }
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
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: const TextField(
                            decoration: InputDecoration(
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
                          child: const TextField(
                            maxLines: 10,
                            decoration: InputDecoration(
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
                            Navigator.pop(context, false);
                          },
                          child: const Text(
                            'Valider',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: const TextField(
                            decoration: InputDecoration(
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
                          child: const TextField(
                            maxLines: 10,
                            decoration: InputDecoration(
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
        );
      });
}
