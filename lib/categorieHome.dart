import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Task.dart';
import 'package:projetmobiles6/projetOrToDo.dart';
import 'package:projetmobiles6/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class categorieHome extends StatefulWidget{

  final String categorieId;

  const categorieHome({Key key, this.categorieId}) : super(key: key);

  @override
  State<categorieHome> createState() => _categorieHomeState();
}

class _categorieHomeState extends State<categorieHome> {

  bool isSearching = false;
  final String categorieId;
  List<Task> allTask = <Task>[];
  String errorText = "";
  bool loading = true;

  _categorieHomeState({this.categorieId});

  final List<Color> _colorList = [
    const Color(0xFFF2DAD3),
    const Color(0xFFFBEDC9),
    const Color(0xFFD7F2D3)];

  @override
  void initState() {
    initData();
  }


  Future<void> initData() async {
    allTask = [];
    try{
      await FirebaseFirestore.instance.collection('task').where("mainElementId",isEqualTo: categorieId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          allTask.add(Task.withDate(result.get("name"),0,0,0,result.get("mainElementId"),false,result.get("deadLine")));
        });
      });
    }catch(error){
      print("error : ");
      print(error);
    }

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading ? const Center(
          child : SpinKitChasingDots(
            color: Color(0xFFFFDDB6),
            size: 50.0,
          ),
        ) :
        allTask.isEmpty ?
        const Center(
            child : Text("Pas de task affectées à la catégorie.")
        ) : ListView.builder(
            itemCount: allTask.length,
            itemBuilder: (context, i) {
              return SizedBox(
                height: MediaQuery.of(context).size.width / 4.5,
                child: Card(
                  margin: i == 0 ? const EdgeInsets.only(top: 10,bottom: 4,left: 4,right: 4) : const EdgeInsets.only(top: 10,bottom: 4,left: 4,right: 4),
                  color: _colorList.elementAt(allTask.elementAt(i).status),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  child: ListTile(
                    title: Text(allTask.elementAt(i).name),
                    onTap: (){
                      //  todo add action when task is pressed
                    },
                  ),
                ),
              );
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
    // TODO: implement _showModalCreateTask
    throw UnimplementedError();
  }

}