import 'package:flutter/material.dart';
// Mengimpor halaman Watchlist, Chat, Modul Edukasi, dan Profil.
import '../utils/WatchlistPage.dart';
import '../utils/chat_screen.dart';
import '../utils/module_education_page.dart';
import 'profile_screen.dart';

// Fungsi utama yang menjalankan aplikasi Flutter.
void main() {
  runApp(MyHomePage());
}

// Kelas utama aplikasi yang merupakan StatelessWidget.
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(), // Menetapkan Home sebagai halaman awal aplikasi.
    );
  }
}

// Kelas Home yang merupakan StatefulWidget.
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// State untuk kelas Home.
class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Menyimpan indeks halaman yang dipilih.

  // Daftar halaman yang dapat dinavigasi menggunakan BottomNavigationBar.
  final List<Widget> _pages = [
    WatchlistPage(),
    ChatScreen(),
    ModuleEducationPage(),
    ProfileScreen(),
  ];

  // Metode untuk menangani perubahan indeks halaman yang dipilih.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman yang dipilih.
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
        currentIndex: _selectedIndex, // Indeks halaman yang saat ini dipilih.
        selectedItemColor: Colors.blueAccent, // Warna item yang dipilih.
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih.
        backgroundColor:
            Colors.lightBlueAccent, // Warna latar belakang BottomNavigationBar.
        onTap: _onItemTapped, // Metode yang dipanggil saat item dipilih.
        selectedIconTheme:
            IconThemeData(color: Colors.blueAccent), // Tema ikon yang dipilih.
      ),
    );
  }
}
