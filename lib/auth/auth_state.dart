// Mengimpor paket-paket yang diperlukan untuk membangun aplikasi Flutter dan menggunakan Firebase Authentication.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Mengimpor halaman utama aplikasi.
import 'package:login_ternak_uang/user/MyHomePage.dart';
// Mengimpor layar login.
import 'login_screen.dart';

// Mendefinisikan kelas AuthState yang merupakan StatelessWidget.
class AuthState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengembalikan StreamBuilder yang memantau perubahan status autentikasi pengguna.
    return StreamBuilder<User?>(
      // Mendengarkan stream perubahan status autentikasi dari Firebase.
      stream: FirebaseAuth.instance.authStateChanges(),
      // Membangun widget berdasarkan status snapshot dari stream.
      builder: (context, snapshot) {
        // Jika koneksi sedang dalam status menunggu, tampilkan indikator loading.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // Jika terdapat data dalam snapshot (pengguna sudah login), tampilkan halaman utama.
        else if (snapshot.hasData) {
          return MyHomePage();
        }
        // Jika tidak ada data (pengguna belum login), tampilkan layar login.
        else {
          return LoginScreen();
        }
      },
    );
  }
}
