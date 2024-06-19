import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user/login_screen.dart';
import 'profile_screen.dart';

class AuthState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return ProfileScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

