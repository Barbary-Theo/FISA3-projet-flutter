import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/projectHome.dart';
import 'package:projetmobiles6/projectSettings.dart';
import 'package:projetmobiles6/projetOrToDo.dart';

class projectMain extends StatefulWidget {
  final String mainElementId;

  const projectMain({Key key, this.mainElementId}) : super(key: key);

  @override
  State<projectMain> createState() =>
      _projectMainState(mainElementId: mainElementId);
}

class _projectMainState extends State<projectMain> {
  int _selectedIndex = 0;
  final String mainElementId;

  _projectMainState({this.mainElementId});

  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      projectHome(mainElementId: mainElementId),
      projetSettings(mainElementId: mainElementId),
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
