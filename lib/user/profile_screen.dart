import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // Untuk menyimpan informasi pengguna yang saat ini masuk
  String?
      _username; // Untuk menyimpan username pengguna yang diambil dari Firestore

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Mendapatkan pengguna yang saat ini masuk
    _loadUserData(); // Memuat data pengguna dari Firestore saat inisialisasi
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      // Mengambil dokumen pengguna dari Firestore berdasarkan UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _username =
            userDoc['username']; // Mengambil username dari dokumen pengguna
      });
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut(); // Proses logout dari Firebase Auth
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Navigasi ke halaman login setelah logout
    );
  }

  void _resetPassword() async {
    if (_user != null) {
      await _auth.sendPasswordResetEmail(
          email: _user!.email!); // Mengirim email reset password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password reset email sent'), // Menampilkan snackbar ketika email reset terkirim
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.lightBlueAccent, // Warna latar belakang AppBar
        automaticallyImplyLeading:
            false, // Tidak menampilkan tombol back secara otomatis
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context), // Tombol logout di AppBar
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                backgroundColor:
                    Colors.grey[300], // Warna latar belakang avatar
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _username ??
                    'Loading...', // Nama pengguna atau 'Loading...' jika belum dimuat
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _user?.email ??
                    'Email', // Email pengguna atau 'Email' jika tidak ada
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Reset Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks pada tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bentuk tombol
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildAccordion(), // Widget untuk daftar expansion tile (accordion)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          _buildExpansionTile(
            'About Us', // Judul expansion tile
            'This is a stock trading app that allows users to trade stocks, track their portfolio, and stay updated with market news. Our mission is to make stock trading accessible and easy for everyone.', // Konten expansion tile
          ),
          _buildExpansionTile(
            'FAQ', // Judul expansion tile
            'Q: How do I start trading?\nA: To start trading, you need to create an account, verify your email, and then you can begin adding funds to your account and start trading.\n\nQ: How secure is this app?\nA: We use the latest security measures to ensure your data and transactions are safe and secure.', // Konten expansion tile
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return ExpansionTile(
      title: Text(title,
          style:
              TextStyle(fontWeight: FontWeight.bold)), // Judul expansion tile
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content,
              style: TextStyle(fontSize: 16)), // Konten expansion tile
        ),
      ],
    );
  }
}
