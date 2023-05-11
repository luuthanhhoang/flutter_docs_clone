import 'package:flutter/material.dart';
import 'package:flutter_google_docs_clone/colors.dart';
import 'package:flutter_google_docs_clone/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final eMessage = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      eMessage.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                signInWithGoogle(ref, context);
              },
              icon: Image.asset(
                'assets/images/g-logo-2.png',
                width: 20,
                height: 20,
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(color: kBlackColor),
              ),
              style: ElevatedButton.styleFrom(
                  maximumSize: const Size(200, 50),
                  backgroundColor: kWhiteColor))),
    );
  }
}
