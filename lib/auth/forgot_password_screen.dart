// Mengimpor paket-paket yang diperlukan untuk membangun aplikasi Flutter dan menggunakan Firebase Authentication.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Mengimpor halaman login.
import 'login_screen.dart';

// Mendefinisikan kelas ForgotPasswordScreen yang merupakan StatefulWidget.
class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

// State kelas untuk ForgotPasswordScreen.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Mendefinisikan instance FirebaseAuth.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Controller untuk mengelola input email dari pengguna.
  final TextEditingController _emailController = TextEditingController();

  // Metode untuk mengirim email reset password.
  void _resetPassword() async {
    try {
      // Mengirim email reset password menggunakan FirebaseAuth.
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      // Menampilkan pesan sukses jika email terkirim.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset link sent!'),
      ));
    } catch (e) {
      // Menangani kesalahan jika terjadi.
      print(e);
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
              // Menampilkan teks "Forgot Password".
              Text(
                'Forgot Password',
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
                      SizedBox(height: 20),
                      // Tombol untuk mengirim permintaan reset password.
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Reset Password',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Tombol untuk kembali ke layar login.
              TextButton(
                onPressed: () {
                  // Navigasi ke layar login saat tombol ditekan.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
