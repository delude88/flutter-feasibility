import 'package:flutter/material.dart';
import 'package:flutter_feasibility/io/repository.dart';
import 'package:flutter_svg/svg.dart';
import '../components/forms/login_form.dart';

// TODO: TBD: Why Screens and not Views? In Swift views can contain other views, not here. To reduce confusion we might use screens => tbc.
class LoginScreen extends StatelessWidget {
  final Repository repository;

  const LoginScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/crown.svg'),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Please sign in using your doozoo Account"),
                    ),
                    LoginForm(
                        repository: repository
                    ),
                  ],
                ))));
  }
}
