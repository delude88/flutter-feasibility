import 'package:flutter/material.dart';
import 'package:flutter_feasibility/store/eventor.dart';

typedef LoginCallback = void Function(String email, String password);

class LoginForm extends StatefulWidget {
  final Eventor eventor;

  const LoginForm({super.key, required this.eventor});

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
    return Column(children: <Widget>[
      Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 600),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          )),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              widget.eventor
                  .connect(_emailController.text, _passwordController.text);
            },
            child: const Text('Login'),
          ))
    ]);
  }
}
