import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feasibility/services/webrtc_service.dart';
import 'package:flutter_feasibility/store/global.dart';
import 'package:flutter_feasibility/store/store.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  final Store store;
  final WebRTCService service;

  RoomScreen({super.key, required this.store})
      : service = WebRTCService(store.eventor);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  StreamSubscription? memberListener;
  List<String> member = [];

  @override
  void dispose() {
    widget.service.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global>(
        builder: (context, global, _) => Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(global.roomId ?? "Loading"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Invite people"),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: widget.store.eventor.leaveRoom,
                tooltip: 'Leave room',
                backgroundColor: Colors.red,
                child: const Icon(Icons.logout),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
