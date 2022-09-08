import 'package:flutter/material.dart';
import 'package:flutter_feasibility/store/store.dart';
import 'package:flutter_feasibility/ui/components/forms/join_form.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  final Store store;

  const HomeScreen({super.key, required this.store});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          title: const Text("Welcome"),
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
                        onPressed: widget.store.eventor.createRoom,
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
                      JoinForm(eventor: widget.store.eventor),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TextButton(
                      onPressed: widget.store.eventor.disconnect,
                      child: const Text("Logout"),
                    ))
              ],
            ),
          ),
        ));
  }
}
