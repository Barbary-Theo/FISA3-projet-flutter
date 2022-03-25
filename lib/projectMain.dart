
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetmobiles6/projectHome.dart';

class projectMain extends StatefulWidget{
  @override
  State<projectMain> createState() => _projectMainState();

}


class _projectMainState extends State<projectMain>{

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    projectHome(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromRGBO(34,139,34,100),
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.exposure_plus_1),
            label: 'Plus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',

          ),
        ],


      ),
    );
  }


}
