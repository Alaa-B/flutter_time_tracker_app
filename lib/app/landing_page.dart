import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/home/home_page.dart';
import '/services/database.dart';

import '../services/auth.dart';
import 'sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserAuth>(
      stream: auth.onStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserAuth? user = snapshot.data;
          if (user?.uid == null) {
            return SignInPage.create(context);
          }
          return Provider<UserAuth>.value(
            value: user!,
            child: Provider<DataBase>(
                create: (_) => FireStoreDataBase(uid: user.uid.toString()),
                child: const HomePage()),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
