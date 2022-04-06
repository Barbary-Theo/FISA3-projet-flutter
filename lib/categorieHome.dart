import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Members.dart';
import 'package:projetmobiles6/model/Task.dart';
import 'package:projetmobiles6/projectHome.dart';
import 'package:projetmobiles6/projetOrToDo.dart';
import 'package:projetmobiles6/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class categorieHome extends StatefulWidget{

  final String categorieId;
  final String categorieName;
  final String mainElementId;

  const categorieHome({Key key, this.categorieId, this.categorieName, this.mainElementId}) : super(key: key);

  @override
  State<categorieHome> createState() => _categorieHomeState(categorieId: categorieId,categorieName : categorieName,mainElementId: mainElementId);
}

class _categorieHomeState extends State<categorieHome> {

  final String categorieId;
  final String categorieName;
  final String mainElementId;
  _categorieHomeState({this.categorieId,this.categorieName,this.mainElementId});

  bool isSearching = false;
  List<Task> allTask = <Task>[];
  String errorText = "";
  bool _loading = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  DateTime _deadLine = DateTime.now();
  final _auth = FirebaseAuth.instance;
  List<String> _allMemberId = <String>[];
  List<Members> _allMembersOfProject = <Members>[];
  List<String> _allMembersEmail = <String>[];
  bool loading = true;
  String _selectedMember = "";
  String _selectedMemberId = "";
  List<DropdownMenuItem<String>> _menuItems = <DropdownMenuItem<String>>[];

  final List<Color> _colorList = [
    const Color(0xFFF2DAD3),
    const Color(0xFFFBEDC9),
    const Color(0xFFD7F2D3)];

  @override
  void initState() {
    initData();
  }

  void addTask(String name, String description, int status, DateTime deadLine){
    try {
      FirebaseFirestore.instance.collection("task").add(
          {
            'mainElementId' : categorieId,
            'name' : name,
            'description' : description,
            'status' : status,
            'deadLine' : deadLine,
            'members' : <String>[_auth.currentUser.uid]
          }
      );
    } catch(error){
      print(error);
    }
    initData();
  }

  Future<void> initData() async {
    setState(() {
      _loading = true;
    });
    allTask = [];
    try{
      await FirebaseFirestore.instance.collection('task').where("mainElementId",isEqualTo: categorieId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          allTask.add(Task.withDate(result.get("name"),0,0,0,result.get("mainElementId"),false,result.get("deadLine").toDate()));
        });
      });
    }catch(error){
      print("error : ");
      print(error);
    }

    _allMemberId = <String>[];
    _allMembersOfProject = <Members>[];
    _allMembersEmail = <String>[];
    try {
      await FirebaseFirestore.instance
          .collection('project')
          .doc(mainElementId)
          .get()
          .then((querySnapshot) {
        List<dynamic> temp = querySnapshot.get("members");
        temp.forEach((element) async {
          await FirebaseFirestore.instance
              .collection('user')
              .where("id", isEqualTo: element.toString())
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {

              _allMembersOfProject
                  .add(Members(result.get("email"), result.get("id")));
              _allMembersEmail.add(result.get("email"));
              _allMemberId.add(result.get("id"));

            });
          });


          if (_allMembersOfProject.length == temp.length - 1) {
            if(_allMembersOfProject.isEmpty){
              setState(() {
                loading = false;
              });
            } else {
              setState(() {
                _selectedMember = _allMembersOfProject.elementAt(0).email;
                _selectedMemberId = _allMembersOfProject.elementAt(0).id;
                loading = false;
                _setMenuItems();
              });
            }
          }
        });
      });
      setState(() {});
    } catch (error) {
      print("error : ");
      print(error);
    }

  }

  void _setMenuItems() {
    _menuItems = <DropdownMenuItem<String>>[];
    _allMembersEmail.forEach((element) {
      _menuItems.add(DropdownMenuItem(value: element, child: Text(element)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading ? const Center(
        child : SpinKitChasingDots(
          color: Color(0xFFFFDDB6),
          size: 50.0,
        ),
      ) :
      allTask.isEmpty ?
      const Center(
          child : Text("Pas de task affectées à la catégorie.")
      ) :

      ListView.builder(
          itemCount: allTask.length + 2,
          itemBuilder: (context, i) {
            Widget widget;
            if(i == 0) {
              widget = Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    alignment: Alignment.topLeft,
                    constraints: const BoxConstraints(
                        minHeight: 1,
                        minWidth: 1
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                        Icons.keyboard_backspace
                    )
                ),
              );
            } else if(i == 1){
              widget = Text(
                categorieName,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,
              );
            } else {
              widget = SizedBox(
                height: MediaQuery.of(context).size.width / 4.5,
                child: Card(
                  margin: i == 0 ? const EdgeInsets.only(top: 10,bottom: 4,left: 4,right: 4) : const EdgeInsets.only(top: 10,bottom: 4,left: 4,right: 4),
                  color: _colorList.elementAt(allTask.elementAt(i-2).status),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: ListTile(
                    title: Text(allTask.elementAt(i-2).name),
                    onTap: (){
                      //  todo add action when task is pressed
                    },
                  ),
                ),
              );
            }
            return widget;
          }
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          _showModalCreateTask(context);
          errorText = "";
        },
        backgroundColor: const Color(0xFF92DEB1),
        child: const Icon(Icons.add),
      ),
    );
  }


  _showModalCreateTask(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
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
                      child:  Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Nom de la catégorie",
                                  fillColor: Colors.white70,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 60,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.height / 5,
                              child: TextField(
                                controller: _descController,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: "Description de la tâche",
                                  fillColor: Colors.white70,
                                ),
                              ),
                            ),

                            TextButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now(),
                                      onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        _deadLine = date;
                                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                                },
                                child: const Text(
                                  'Selectionner une DeadLine',
                                  style: TextStyle(color: Colors.blue),
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 40,
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
                                print("id : " );
                                print(categorieId);
                                if(_nameController.text.isNotEmpty){
                                  addTask(_nameController.text.trim(),_descController.text.trim(),0,_deadLine);
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
                  )

              ),

            ),
          );
        });
  }

}