import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/model/Members.dart';
import 'package:projetmobiles6/model/Task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class categorieHome extends StatefulWidget {
  final String categorieId;
  final String categorieName;
  final String mainElementId;

  const categorieHome(
      {Key key, this.categorieId, this.categorieName, this.mainElementId})
      : super(key: key);

  @override
  State<categorieHome> createState() => _categorieHomeState(
      categorieId: categorieId,
      categorieName: categorieName,
      mainElementId: mainElementId);
}

class _categorieHomeState extends State<categorieHome> {
  final String categorieId;
  final String categorieName;
  final String mainElementId;

  _categorieHomeState(
      {this.categorieId, this.categorieName, this.mainElementId});

  bool isSearching = false;
  List<Task> allTask = <Task>[];
  String errorText = "";
  bool _loading = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _deadLine = DateTime.now();
  final _auth = FirebaseAuth.instance;
  List<Members> _allMembersOfCategorie = <Members>[];
  List<Members> _allMembersOfTask = <Members>[];
  final List<String> _allMembersEmail = <String>[];
  String _selectedMember = "";
  String _selectedMemberId = "";
  List<DropdownMenuItem<String>> _menuItems = <DropdownMenuItem<String>>[];
  final TextEditingController _userToAdd = TextEditingController();
  String taskIdTaskPressed = "";
  String taskNameTaskPressed = "";
  String taskDescTaskPressed = "";
  DateTime taskDeadLinePressed = DateTime.now();
  int _status = 0;
  final GlobalKey _dialogKey = GlobalKey();

  final List<Color> _colorList = [
    const Color(0xFFF2DAD3),
    const Color(0xFFFBEDC9),
    const Color(0xFFD7F2D3)
  ];

  @override
  void initState() {
    initData();
  }

  void updateDialog() {
    if (_dialogKey.currentState != null && _dialogKey.currentState.mounted) {
      _dialogKey.currentState.setState(() {});
    }
  }

  void openShowTaskInfoModal() {
    _showModalTaskInfo(context);
  }

  Future<void> setAllUserOfTask() async {
    _allMembersOfTask = <Members>[];
    await FirebaseFirestore.instance
        .collection('task')
        .doc(taskIdTaskPressed)
        .get()
        .then((querySnapshot) async {
      List<dynamic> temp = querySnapshot.get("members");
      temp.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('user')
            .where("id", isEqualTo: element.toString())
            .get()
            .then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            setState(() {
              _allMembersOfTask
                  .add(Members(result.get("email"), result.get("id")));
            });
            _setMenuItems();
          }
        });
      });
    });
  }

  void addTask(String name, String description, int status, DateTime deadLine) {
    try {
      FirebaseFirestore.instance.collection("task").add({
        'mainElementId': categorieId,
        'name': name,
        'description': description,
        'status': status,
        'deadLine': deadLine,
        'members': <String>[_auth.currentUser.uid]
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    initData();
  }

  Future<void> addMembers(List<dynamic> temp) async {
    _allMembersOfCategorie = <Members>[];
    for (var element in temp) {
      await FirebaseFirestore.instance
          .collection('user')
          .where("id", isEqualTo: element.toString())
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          _allMembersOfCategorie
              .add(Members(result.get("email"), result.get("id")));
        }
      });

      if (_allMembersOfCategorie.length == temp.length) {
        if (_allMembersOfCategorie.isEmpty) {
          setState(() {
            _loading = false;
          });
        } else {
          setState(() {
            _selectedMember = _allMembersOfCategorie.elementAt(0).email;
            _selectedMemberId = _allMembersOfCategorie.elementAt(0).id;

            _loading = false;
          });
        }
      }
    }

    updateDialog();
  }

  Future<void> initData() async {
    allTask = [];

    try {
      await FirebaseFirestore.instance
          .collection('task')
          .where("mainElementId", isEqualTo: categorieId)
          .get()
          .then((querySnapshot) async {
        for (var result in querySnapshot.docs) {
          allTask.add(Task.withDate(
              result.get("name"),
              result.get("status"),
              0,
              0,
              result.get("mainElementId"),
              false,
              result.get("deadLine").toDate(),
              result.id,
              result.get("description")));
          List<dynamic> temp = result.get("members");

          await addMembers(temp);
        }
        setState(() {
          _loading = false;
        });
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _setMenuItems() async {
    _menuItems = <DropdownMenuItem<String>>[];
    for (var element in _allMembersOfTask) {
      _menuItems.add(
          DropdownMenuItem(value: element.email, child: Text(element.email)));
    }
    updateDialog();
  }

  Future<void> _addUser(String email) async {
    bool canAdd = true;
    for (var element in _allMembersEmail) {
      if (email == element) {
        canAdd = false;
      }
    }
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
          .collection('task')
          .doc(taskIdTaskPressed)
          .update({
        'members': FieldValue.arrayUnion([id])
      });
    }

    await initData();
    await setAllUserOfTask();
    setState(() {});
    updateDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(
              child: SpinKitChasingDots(
                color: Color(0xFFFFDDB6),
                size: 50.0,
              ),
            )
          : allTask.isEmpty
              ? ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, i) {
                    Widget widget;
                    if (i == 0) {
                      widget = Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            alignment: Alignment.topLeft,
                            constraints:
                                const BoxConstraints(minHeight: 1, minWidth: 1),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.keyboard_backspace)),
                      );
                    } else if (i == 1) {
                      widget = Text(
                        categorieName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      widget = const Center(
                        child: Text("Pas de tâche affectée à la catégorie"),
                      );
                    }
                    return widget;
                  })
              : ListView.builder(
                  itemCount: allTask.length + 2,
                  itemBuilder: (context, i) {
                    Widget widget;
                    if (i == 0) {
                      widget = Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            alignment: Alignment.topLeft,
                            constraints:
                                const BoxConstraints(minHeight: 1, minWidth: 1),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.keyboard_backspace)),
                      );
                    } else if (i == 1) {
                      widget = Text(
                        categorieName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      widget = SizedBox(
                        height: MediaQuery.of(context).size.width / 4.5,
                        child: Card(
                          margin: i == 0
                              ? const EdgeInsets.only(
                                  top: 10, bottom: 4, left: 4, right: 4)
                              : const EdgeInsets.only(
                                  top: 10, bottom: 4, left: 4, right: 4),
                          color: _colorList
                              .elementAt(allTask.elementAt(i - 2).status),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: ListTile(
                            title: Text(allTask.elementAt(i - 2).name),
                            onTap: () {
                              taskIdTaskPressed = allTask.elementAt(i - 2).id;
                              taskNameTaskPressed =
                                  allTask.elementAt(i - 2).name;
                              taskDescTaskPressed =
                                  allTask.elementAt(i - 2).desc;
                              taskDeadLinePressed =
                                  allTask.elementAt(i - 2).deadLine;
                              _status = allTask.elementAt(i - 2).status;
                              setAllUserOfTask();
                              _showModalTaskInfo(context);
                              updateDialog();
                            },
                          ),
                        ),
                      );
                    }
                    return widget;
                  }),
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

  Future<void> _showModalCreateTask(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: const EdgeInsets.only(bottom: 10.0),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF92DEB1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0)),
                                      ),
                                      child: const Text(
                                        "Ajout d'une tâche",
                                        style: TextStyle(
                                            color: Color(0xFF696868),
                                            fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ]),
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
                                  hintText: "Nom de la tâche",
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
                                      onChanged: (date) {}, onConfirm: (date) {
                                    _deadLine = date;
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFFFDDB6)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_nameController.text.isNotEmpty) {
                                  addTask(
                                      _nameController.text.trim(),
                                      _descController.text.trim(),
                                      0,
                                      _deadLine);
                                }
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                'Valider',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )));
          });
        });
  }

  Future<void> _showModalTaskInfo(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              key: _dialogKey,
              builder: (BuildContext context, StateSetter setState) {
                return Dialog(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                  "Nom de la tâche : " + taskNameTaskPressed),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child:
                                  Text("Description : " + taskDescTaskPressed),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text("Date de fin : " +
                                  taskDeadLinePressed.year.toString() +
                                  "/" +
                                  taskDeadLinePressed.month.toString() +
                                  "/" +
                                  taskDeadLinePressed.day.toString()),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Column(
                                children: [
                                  RadioListTile(
                                      title: const Text('Pas commencée'),
                                      value: 0,
                                      groupValue: _status,
                                      onChanged: (int value) async {
                                        _status = value;
                                        await FirebaseFirestore.instance
                                            .collection('task')
                                            .doc(taskIdTaskPressed)
                                            .update({'status': _status});
                                        for (var element in allTask) {
                                          if (element.id == taskIdTaskPressed) {
                                            element.status = _status;
                                          }
                                        }
                                        initData();
                                        setState(() {});
                                      }),
                                  RadioListTile(
                                      title: const Text('Commencée'),
                                      value: 1,
                                      groupValue: _status,
                                      onChanged: (value) async {
                                        _status = value;
                                        await FirebaseFirestore.instance
                                            .collection('task')
                                            .doc(taskIdTaskPressed)
                                            .update({'status': _status});
                                        for (var element in allTask) {
                                          if (element.id == taskIdTaskPressed) {
                                            element.status = _status;
                                          }
                                        }
                                        initData();
                                        setState(() {});
                                      }),
                                  RadioListTile(
                                      title: const Text('Terminée'),
                                      value: 2,
                                      groupValue: _status,
                                      onChanged: (value) async {
                                        _status = value;
                                        await FirebaseFirestore.instance
                                            .collection('task')
                                            .doc(taskIdTaskPressed)
                                            .update({'status': _status});

                                        for (var element in allTask) {
                                          if (element.id == taskIdTaskPressed) {
                                            element.status = _status;
                                          }
                                        }
                                        initData();
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height >
                                      MediaQuery.of(context).size.width
                                  ? MediaQuery.of(context).size.width / 4.8
                                  : MediaQuery.of(context).size.height / 4.8,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _allMembersOfTask.length + 2,
                                  itemBuilder: (BuildContext context, int i) {
                                    Widget circle;
                                    if (i == _allMembersOfTask.length) {
                                      circle = CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFF92DEB1),
                                        radius:
                                            MediaQuery.of(context).size.height >
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async {
                                            await _showModalRemoveMember(
                                                context);
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    } else if (i ==
                                        _allMembersOfTask.length + 1) {
                                      circle = CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFFFC6C6),
                                        radius:
                                            MediaQuery.of(context).size.height >
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                        child: IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            _showModalAddUser(context);
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    } else {
                                      circle = CircleAvatar(
                                        backgroundColor:
                                            _colorList.elementAt(i % 4),
                                        radius:
                                            MediaQuery.of(context).size.height >
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                        child: Text(_allMembersOfTask
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
                          ]),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Future<void> _showModalRemoveMember(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: const EdgeInsets.only(bottom: 10.0),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 3.2,
                    child: Center(
                      child: Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFC6C6),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                    ),
                                    child: const Text(
                                      "Suppression",
                                      style: TextStyle(
                                          color: Color(0xFF696868),
                                          fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          ),
                          SizedBox(
                              child: DropdownButton<String>(
                            value: _selectedMember,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onChanged: (String value) {
                              setState(() {
                                _selectedMember = value;
                                for (var element in _allMembersOfTask) {
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
                          SizedBox(
                            width: MediaQuery.of(context).size.height / 5,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFFFDDB6)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context, false);
                                if (_selectedMember !=
                                    _auth.currentUser.email) {
                                  await FirebaseFirestore.instance
                                      .collection('task')
                                      .doc(taskIdTaskPressed)
                                      .update({
                                    "members": FieldValue.arrayRemove(
                                        [_selectedMemberId])
                                  });
                                  // Navigator.pop(context, false);
                                  await initData();
                                  await setAllUserOfTask();
                                  updateDialog();

                                  // openShowTaskInfoModal();
                                }
                                // setState(() {});
                              },
                              child: const Text(
                                'Valider',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )));
          });
        });
  }

  Future<void> _showModalAddUser(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding: const EdgeInsets.only(bottom: 10.0),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 3.2,
                    child: Center(
                      child: Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF92DEB1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                    ),
                                    child: const Text(
                                      "Affecter un membre",
                                      style: TextStyle(
                                          color: Color(0xFF696868),
                                          fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
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
                          SizedBox(
                            width: MediaQuery.of(context).size.height / 5,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFFFDDB6)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context, false);
                                if (_userToAdd.text.isNotEmpty) {
                                  await _addUser(
                                      _userToAdd.text.toString().trim());
                                }
                              },
                              child: const Text(
                                'Valider',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )));
          });
        });
  }
}
