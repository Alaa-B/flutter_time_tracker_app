import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/services/auth.dart';
import '/widgets/avatar.dart';
import '/widgets/platform_alert_dialog.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final didRequestSignOut = await const PlatformAlertDialog(
      title: 'Log Out',
      content: 'Are you shore that you want to Sign out',
      cancelActionText: 'Cancel',
      defaultActionText: 'Log Out',
    ).show(context);
    if (didRequestSignOut == true) {
      try {
        await auth.signOut();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Account'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Icon(Icons.logout),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
      body: Container(),
    );
  }

  _buildUserInfo(UserAuth user) {
    return Column(
      children: [
        Avatar(
          photoURL: user.photoURL,
          radius: 45,
        ),
        const SizedBox(
          height: 8,
        ),
        if (user.displayName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              user.displayName!,
              style: const TextStyle(color: Colors.black),
            ),
          ),
      ],
    );
  }
}
