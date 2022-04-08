import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/projetOrToDo.dart';
import 'package:projetmobiles6/toDoHome.dart';
import 'package:projetmobiles6/toDoSettings.dart';

class toDoMain extends StatefulWidget {
  final String mainElementId;

  const toDoMain({Key key, this.mainElementId}) : super(key: key);

  @override
  State<toDoMain> createState() => _toDoMainState(mainElementId: mainElementId);
}

class _toDoMainState extends State<toDoMain> {
  int _selectedIndex = 0;
  final String mainElementId;

  _toDoMainState({this.mainElementId});

  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      toDoHome(mainElementId: mainElementId),
      toDoSettings(mainElementId: mainElementId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFFEEEDED),
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => projet()),
              (route) => false);
        },
        backgroundColor: const Color(0xFFF2DAD3),
        child: const Icon(Icons.home),
      ),
    );
  }
}
