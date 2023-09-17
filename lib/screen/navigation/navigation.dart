import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_app/admin/admin_home.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';

class Navigations extends StatelessWidget {
  const Navigations({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const BottomBars();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.uid == 'ehEWIZZymdNkj7UZz2CM9L7zBUd2') {
          return const AdminHome();
        }

        return const BottomBars();
      },
    );
  }
}
