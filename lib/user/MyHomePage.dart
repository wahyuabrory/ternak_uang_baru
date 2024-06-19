import 'package:flutter/material.dart';
import 'package:login_ternak_uang/user/module_education_page.dart';
import '../profile_screen.dart';
import 'WatchlistPage.dart';
import 'chat_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    WatchlistPage(),
    ChatScreen(),
    ModuleEducationPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent, // Color of the selected item
        unselectedItemColor: Colors.grey, // Color of the unselected items
        backgroundColor: Colors.lightBlueAccent, // Light blue background color
        onTap: _onItemTapped,
        selectedIconTheme:
            IconThemeData(color: Colors.blueAccent), // Icon color when selected
      ),
    );
  }
}
