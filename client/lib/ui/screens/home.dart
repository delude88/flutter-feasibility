import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feasibility/bloc/global_bloc.dart';
import 'package:flutter_feasibility/io/repository.dart';
import 'package:flutter_feasibility/ui/components/forms/join_form.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  final Repository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: BlocBuilder<GlobalBloc, GlobalState>(
              builder: (context, state) => Text("Welcome ${state.userId}")),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset('assets/crown.svg'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: repository.createRoom,
                        child: const Text("Create a room"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      const Text("or enter an invitation code:"),
                      JoinForm(repository: repository),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TextButton(
                      onPressed: repository.disconnect,
                      child: const Text("Logout"),
                    ))
              ],
            ),
          ),
        ));
  }
}
