import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/constant/constants.dart';

import '../general/profil.dart';

class generalToolbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => generalToolbarState();
}

class generalToolbarState extends State<generalToolbar> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
   final List<Widget> _widgetOptions = <Widget>[

    const Text('Index 1: buisness', style: optionStyle),
    const Text('Index 2: School', style: optionStyle),
     profil(),

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
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Поездки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Сообщения',
          ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Профиль',
              ),
        ],
              currentIndex: _selectedIndex,
              selectedItemColor: constants.stateBlue,
              onTap: _onItemTapped,
            ));
  }
}
