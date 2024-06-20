// Mengimpor paket-paket yang diperlukan untuk membangun aplikasi Flutter.
import 'package:flutter/material.dart';
// Mengimpor layar login dari folder auth.
import 'package:login_ternak_uang/auth/login_screen.dart';
// Mengimpor status autentikasi dari folder auth.
import 'auth/auth_state.dart';
// Mengimpor Firebase core untuk inisialisasi Firebase.
import 'package:firebase_core/firebase_core.dart';
// Mengimpor opsi Firebase yang dikonfigurasi khusus untuk aplikasi ini.
import 'auth/firebase_options.dart';

// Fungsi utama yang akan dijalankan saat aplikasi dimulai.
Future<void> main() async {
  // Memastikan bahwa widget binding telah diinisialisasi sebelum menjalankan aplikasi.
  WidgetsFlutterBinding.ensureInitialized();
  // Menunggu inisialisasi Firebase dengan menggunakan opsi yang telah dikonfigurasi.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Menjalankan aplikasi dengan MyApp sebagai root widget.
  runApp(MyApp());
}

// Kelas utama dari aplikasi yang merupakan StatelessWidget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengembalikan MaterialApp sebagai root dari aplikasi.
    return MaterialApp(
      // Menetapkan judul aplikasi.
      title: 'Ternak Uang',
      // Menetapkan tema dasar aplikasi dengan warna utama biru.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Menetapkan halaman utama aplikasi menjadi AuthState.
      home: AuthState(),
      // Menetapkan rute untuk navigasi dalam aplikasi.
      routes: {
        // Rute untuk layar login yang mengarah ke LoginScreen.
        '/login_screen': (context) => LoginScreen(),
      },
    );
  }
}
