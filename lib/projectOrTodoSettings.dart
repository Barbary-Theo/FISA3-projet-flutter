import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class projetOrToDoSettings extends StatefulWidget{

  final String mainElementId;

  const projetOrToDoSettings({Key key, this.mainElementId}) : super(key: key);


  @override
  State<projetOrToDoSettings> createState() => _projetOrToDoSettingsState(mainElementId: mainElementId);

}

class _projetOrToDoSettingsState extends State<projetOrToDoSettings>{
  final String mainElementId;
  final FirebaseAuth auth = FirebaseAuth.instance;
  _projetOrToDoSettingsState({this.mainElementId});
  
  String _projectName = "MAXI PROUT";
  String _projectDesc = "";
  bool loading = true;
  List<String> _allUserId = <String>[];
  List<String> _allUserName = <String>[];
  
  @override
  void initState() {
    initializeProjectData();

  }

  Future<void> initializeProjectData() async {
    try {
      print("recupération data project");
      await FirebaseFirestore.instance.collection('project').doc(mainElementId).get().then((querySnapshot) {
        _projectName = querySnapshot.get("name");
        _projectDesc = querySnapshot.get("description");
        List<dynamic> temp = querySnapshot.get("members");
        temp.forEach((element) {
          _allUserId.add(element.toString());
        });
      });



      print("fin recupération data project");
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
        body : loading ? const Center(
          child : SpinKitChasingDots(
            color: Color(0xFFFFDDB6),
            size: 50.0,
          ),
        ) :Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Center(
              child: Text(_projectName),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Center(
              child: Text(_projectDesc),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
            ),
            Divider(color: Colors.black, height: 1),
            // ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: _allUserId.length,
            //     itemBuilder: (context, i) {
            //       return CircleAvatar(
            //         backgroundColor: const Color(0xFFDBBFFF),
            //         radius: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width / 10 : MediaQuery.of(context).size.height / 10,
            //         child: Text(_allUserId[i]),
            //       );
            //     }
            // ),
            Divider(color: Colors.black, height: 1),
          ],
        )
    );
  }

}