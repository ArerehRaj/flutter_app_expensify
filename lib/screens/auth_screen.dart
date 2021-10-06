import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expensify'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: const Center(
          child: Text('This is the Auth Screen'),
        ),
      ),
    );
  }
}
