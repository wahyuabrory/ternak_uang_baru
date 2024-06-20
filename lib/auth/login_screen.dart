// Mengimpor paket-paket yang diperlukan untuk membangun aplikasi Flutter dan menggunakan Firebase Authentication.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Mengimpor halaman-halaman lain yang akan digunakan.
import 'package:login_ternak_uang/user/MyHomePage.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

// Mendefinisikan kelas LoginScreen yang merupakan StatefulWidget.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// State kelas untuk LoginScreen.
class _LoginScreenState extends State<LoginScreen> {
  // Mendefinisikan instance FirebaseAuth.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Controller untuk mengelola input email dan password dari pengguna.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Metode untuk login menggunakan email dan password.
  void _login() async {
    try {
      // Mencoba untuk login menggunakan email dan password yang diberikan.
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigasi ke halaman utama jika login berhasil.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Menangani kesalahan jika login gagal.
      print(e);
      // Menampilkan pesan kesalahan menggunakan dialog.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text('Kata Sandi Salah atau Email Tidak Terdaftar'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengembalikan widget Scaffold yang merupakan struktur dasar halaman.
    return Scaffold(
      // Menetapkan warna latar belakang.
      backgroundColor: Colors.lightBlueAccent,
      // Menggunakan Container untuk memberikan padding di sekitar konten.
      body: Container(
        padding: EdgeInsets.all(16.0),
        // Menggunakan Center untuk memusatkan konten secara vertikal dan horizontal.
        child: Center(
          // Menggunakan SingleChildScrollView untuk memungkinkan scroll jika konten melebihi layar.
          child: SingleChildScrollView(
            // Menggunakan Column untuk menata widget secara vertikal.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Menampilkan logo aplikasi.
                Image.asset(
                  'images/logo.png', // Path to your logo asset
                  height: 100,
                ),
                SizedBox(height: 16),
                // Menampilkan teks "Ternak Uang!".
                Text(
                  'Ternak Uang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // Menggunakan Card untuk membuat tampilan input lebih menarik.
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // TextField untuk input email.
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 12),
                        // TextField untuk input password.
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        // Tombol untuk login.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        // Baris untuk tombol "Forgot Password?" dan "Signup".
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Tombol untuk navigasi ke layar lupa kata sandi.
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            // Tombol untuk navigasi ke layar pendaftaran.
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Signup',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
