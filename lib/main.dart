import 'package:flutter/material.dart';
import 'package:login_ternak_uang/user/login_screen.dart';
import 'auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ternak Uang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthState(),
      routes: {
        '/login_screen': (context) =>
            LoginScreen(), // Add the success screen route
      },
    );
  }
}
