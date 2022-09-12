import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feasibility/bloc/global_bloc.dart';
import 'package:flutter_feasibility/io/repository.dart';

import '../components/members.dart';

class RoomScreen extends StatefulWidget {
  final Repository repository;

  RoomScreen({super.key, required this.repository});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  StreamSubscription? memberListener;
  List<String> member = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text('Room ${state.roomId}'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[Text("Invite people"), Members()],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: widget.repository.leaveRoom,
                tooltip: 'Leave room',
                backgroundColor: Colors.red,
                child: const Icon(Icons.logout),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
