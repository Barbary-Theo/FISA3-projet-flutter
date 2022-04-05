import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/model/Members.dart';

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

  String _projectName = "";
  String _projectDesc = "";
  bool loading = true;
  List<String> _allMemberId = <String>[];
  List<Members> _allMembers = <Members>[];
  List<String> _allMembersEmail = <String>[];
  String _selectedMember = "";
  String _selectedMemberId = "";
  List<DropdownMenuItem<String>> _menuItems = <DropdownMenuItem<String>>[];

  @override
  void initState() {
    initializeProjectData();

  }

  void setMenuItems(){
    _menuItems = <DropdownMenuItem<String>>[];
    print(_allMembersEmail);
    _allMembersEmail.forEach((element) {
      print("element : " + element);
      _menuItems.add(DropdownMenuItem(value: element,child: Text(element)));
    });
    print("allmembers email lenght = " + _allMembersEmail.length.toString());
  }



  Future<void> initializeProjectData() async {
    _allMemberId = <String>[];
    _allMembers = <Members>[];
    _allMembersEmail = <String>[];
    try {
      print("recupération data project");
      await FirebaseFirestore.instance.collection('project').doc(mainElementId).get().then((querySnapshot) {
        _projectName = querySnapshot.get("name");
        _projectDesc = querySnapshot.get("description");
        List<dynamic> temp = querySnapshot.get("members");
        temp.forEach((element) async {
          await FirebaseFirestore.instance.collection('user').where("id",isEqualTo: element.toString()).get().then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              _allMembers.add(Members(result.get("email"),result.get("id")));
              _allMembersEmail.add(result.get("email"));
              _allMemberId.add(result.get("id"));
            });
          });

          if(_allMembers.length == temp.length){
            setState(() {
              print("prout");
              _selectedMember = _allMembers.elementAt(0).email;
              _selectedMemberId = _allMembers.elementAt(0).id;
              loading = false;
              setMenuItems();
            });
          }

        });
      });
      setState(() {

      });

      print(_allMemberId);
    }catch(error){
      print("error : ");
      print(error);
    }
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
              height: MediaQuery.of(context).size.height / 50,
            ),
            Divider(color: Colors.black, height: 1),

            SizedBox(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allMembers.length + 2,
                  itemBuilder: (BuildContext context, int i) {
                    Widget circle;
                    if(i == _allMembers.length ){
                      print(_allMembers.length);
                      circle = CircleAvatar(
                        backgroundColor: const Color(0xFFDBBFFF),
                        radius: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width / 10 : MediaQuery.of(context).size.height / 10,
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: (){
                            _showModalRemoveMember(context);
                          },
                        ),
                      );
                    }else if(i == _allMembers.length + 1 ){
                      print(_allMembers.length);
                      circle = CircleAvatar(
                        backgroundColor: const Color(0xFFDBBFFF),
                        radius: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width / 10 : MediaQuery.of(context).size.height / 10,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: (){

                          },
                        ),
                      );
                    } else {
                      circle = CircleAvatar(
                        backgroundColor: const Color(0xFFDBBFFF),
                        radius: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width / 10 : MediaQuery.of(context).size.height / 10,
                        child: Text(_allMembers.elementAt(i).email.characters.characterAt(0).toString().toUpperCase()),

                      );
                    }
                    return circle;
                  }
              ),
            ),
            Divider(color: Colors.black, height: 1),
          ],
        )
    );
  }



  _showModalRemoveMember(context) {
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
                      child:  Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: DropdownButton<String>(
                                  value: _selectedMember,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  onChanged: (String value) {
                                    setState(() {

                                      _selectedMember = value;
                                      print(_selectedMember);
                                      for (var element in _allMembers) {
                                        if(element.email == value){
                                          _selectedMemberId = element.id;
                                        }
                                      }
                                    });
                                  },
                                  items: _menuItems,
                                )
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
                              onPressed: () async {
                                if(_selectedMember != auth.currentUser.email){
                                  await FirebaseFirestore.instance.collection('project').doc(mainElementId).update({"members": FieldValue.arrayRemove([_selectedMemberId])});
                                }
                                Navigator.pop(context, false);
                                initializeProjectData();
                                setState(() {

                                });
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