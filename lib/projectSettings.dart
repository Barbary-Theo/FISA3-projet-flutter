import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projetmobiles6/model/Members.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class projetSettings extends StatefulWidget {
  final String mainElementId;

  const projetSettings({Key key, this.mainElementId}) : super(key: key);

  @override
  State<projetSettings> createState() =>
      _projetSettingsState(mainElementId: mainElementId);
}

class _projetSettingsState extends State<projetSettings> {
  final String mainElementId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _projetSettingsState({this.mainElementId});

  String _projectName = "";
  String _projectDesc = "";
  bool loading = true;
  List<String> _allMemberId = <String>[];
  List<Members> _allMembersOfProject = <Members>[];
  List<String> _allMembersEmail = <String>[];
  String _selectedMember = "";
  String _selectedMemberId = "";
  List<DropdownMenuItem<String>> _menuItems = <DropdownMenuItem<String>>[];
  final TextEditingController _userToAdd = TextEditingController();
  final List<Color> _colorList = [
    const Color(0xFFD7F2D3),
    const Color(0xFFD8D2ED),
    const Color(0xFFFFDDB6),
    const Color(0xFFFFDDB6),
  ];

  @override
  void initState() {
    _initializeProjectData();
  }

  void _setMenuItems() {
    _menuItems = <DropdownMenuItem<String>>[];
    _allMembersEmail.forEach((element) {
      print("element : " + element);
      _menuItems.add(DropdownMenuItem(value: element, child: Text(element)));
    });
  }

  Future<void> _initializeProjectData() async {
    _allMemberId = <String>[];
    _allMembersOfProject = <Members>[];
    _allMembersEmail = <String>[];
    try {
      await FirebaseFirestore.instance
          .collection('project')
          .doc(mainElementId)
          .get()
          .then((querySnapshot) {
        _projectName = querySnapshot.get("name");
        _projectDesc = querySnapshot.get("description");
        List<dynamic> temp = querySnapshot.get("members");
        temp.forEach((element) async {
          await FirebaseFirestore.instance
              .collection('user')
              .where("id", isEqualTo: element.toString())
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if (result.get("email") != _auth.currentUser.email) {
                _allMembersOfProject
                    .add(Members(result.get("email"), result.get("id")));
                _allMembersEmail.add(result.get("email"));
                _allMemberId.add(result.get("id"));
              }
            });
          });

          if (_allMembersOfProject.length == temp.length - 1) {
            if (_allMembersOfProject.isEmpty) {
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
      setState(() {
        loading = false;
      });
    } catch (error) {
      print("error : ");
      print(error);
    }
  }

  Future<void> _addUser(String email) async {
    bool canAdd = true;
    _allMembersEmail.forEach((element) {
      if (email == element) {
        canAdd = false;
      }
    });
    String id = "";

    await FirebaseFirestore.instance
        .collection('user')
        .where("email", isEqualTo: email)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        id = result.get("id");
      }
    });

    if (canAdd) {
      FirebaseFirestore.instance
          .collection('project')
          .doc(mainElementId)
          .update({
        'members': FieldValue.arrayUnion([id])
      });
    }

    _initializeProjectData();
  }

  Future<void> _deleteProject() async {
    try {

      await FirebaseFirestore.instance.collection("categorie").where(
          "project", isEqualTo: mainElementId).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          FirebaseFirestore.instance.collection("categorie")
              .doc(result.id)
              .delete();
        }
      });

      await FirebaseFirestore.instance
          .collection("project")
          .doc(mainElementId)
          .delete();

      //Todo : Remove all task link to categorie

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => projetOrToDo()),
          (route) => false);
    } catch (e) {
      print("error : ");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? const Center(
                child: SpinKitChasingDots(
                  color: Color(0xFFFFDDB6),
                  size: 50.0,
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  const Center(
                    child: Text(
                      "Nom du projet",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Center(
                    child: Text(
                      _projectName,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  const Center(
                    child: Text(
                      "Description du projet",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Center(
                    child: Text(_projectDesc),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFFFC6C6)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _sureToDelete(context);
                    },
                    child: const Text(
                      'Supprimer le projet',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                  ),
                  const Divider(color: Colors.black, height: 1),
                  SizedBox(
                    height: MediaQuery.of(context).size.height >
                            MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width / 4.8
                        : MediaQuery.of(context).size.height / 4.8,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _allMembersOfProject.length + 2,
                        itemBuilder: (BuildContext context, int i) {
                          Widget circle;
                          if (i == _allMembersOfProject.length) {
                            circle = CircleAvatar(
                              backgroundColor: const Color(0xFF92DEB1),
                              radius: MediaQuery.of(context).size.height >
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.width / 10
                                  : MediaQuery.of(context).size.height / 10,
                              child: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    _showModalRemoveMember(context);
                                  });
                                },
                              ),
                            );
                          } else if (i == _allMembersOfProject.length + 1) {
                            circle = CircleAvatar(
                              backgroundColor: const Color(0xFFFFC6C6),
                              radius: MediaQuery.of(context).size.height >
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.width / 10
                                  : MediaQuery.of(context).size.height / 10,
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _showModalAddUser(context);
                                },
                              ),
                            );
                          } else {
                            circle = CircleAvatar(
                              backgroundColor: _colorList.elementAt(i % 4),
                              radius: MediaQuery.of(context).size.height >
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.width / 10
                                  : MediaQuery.of(context).size.height / 10,
                              child: Text(_allMembersOfProject
                                  .elementAt(i)
                                  .email
                                  .characters
                                  .characterAt(0)
                                  .toString()
                                  .toUpperCase()),
                            );
                          }
                          return circle;
                        }),
                  ),
                  const Divider(color: Colors.black, height: 1),
                ],
              ));
  }

  Future<void> _showModalRemoveMember(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              contentPadding: EdgeInsets.only(bottom: 10.0),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: Center(
                  child: Column(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF92DEB1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0)),
                                ),
                                child: Text("Suppression",
                                    style: TextStyle(
                                        color: Color(0xFF696868),
                                        fontSize: 25),
                                textAlign: TextAlign.center,),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: DropdownButton<String>(
                            value: _selectedMember,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onChanged: (String value) {
                              setState(() {
                                _selectedMember = value;
                                for (var element in _allMembersOfProject) {
                                  if (element.email == value) {
                                    _selectedMemberId = element.id;
                                  }
                                }
                              });
                            },
                            items: _menuItems,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.height / 5,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFFFDDB6),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_selectedMember != _auth.currentUser.email) {
                              await FirebaseFirestore.instance
                                  .collection('project')
                                  .doc(mainElementId)
                                  .update({
                                "members":
                                    FieldValue.arrayRemove([_selectedMemberId])
                              });
                            }
                            Navigator.pop(context, false);
                            _initializeProjectData();
                            setState(() {});
                          },
                          child: const Text(
                            'Valider',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  _showModalAddUser(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Ajout",
                      style: TextStyle(color: Color(0xFF696868), fontSize: 25)),
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF92DEB1),
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextField(
                          controller: _userToAdd,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "Email de l'utilisateur",
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
                              const Color(0xFFFFDDB6)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_userToAdd.text.isNotEmpty) {
                            _addUser(_userToAdd.text.toString().trim());
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
              ),
            ),
          );
        });
  }

  _sureToDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                    child: Column(
                  children: [
                    Text("Confirmation",
                        style:
                            TextStyle(color: Color(0xFF696868), fontSize: 25)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFFDDB6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _deleteProject();
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'Oui',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFFC6C6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'Non',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )),
              ));
        });
  }
}
