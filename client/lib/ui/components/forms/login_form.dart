import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onLogin;

  const LoginForm({super.key, required this.onLogin});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}


class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              controller: _passwordController,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {},
                child: const Text('Login'),
              )
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () { context.pop(); },
                child: const Text('Back'),
              )
          )
        ]
    );
  }

}