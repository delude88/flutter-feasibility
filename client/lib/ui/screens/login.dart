import 'package:flutter/material.dart';
import '../components/forms/login_form.dart';

// TODO: TBD: Why Screens and not Views? In Swift views can contain other views, not here. To reduce confusion we might use screens => tbc.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: LoginForm(onLogin: () { print("Try to login baby"); },),
        )
    );
  }

}