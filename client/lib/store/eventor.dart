import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const url = 'ws://localhost:3000';

class Event {
  final String event;
  final dynamic payload;

  Event(this.event, this.payload);
}

/// Event source is a simple emitter of events.
/// These events are all sourced via an websocket connection.
/// Use this class to listen and react to specific events (e.g. models or a store).
/// TODO: Split into Connection and event source and action dispatcher
class Eventor {
  final Map<String, List<Function>> listeners =
      HashMap<String, List<Function>>();
  final StreamController<Event> _eventStreamController = StreamController<Event>.broadcast();
  WebSocketChannel? _channel;

  void _emit(String event, [dynamic payload]) {
    _eventStreamController
    listeners[event]?.forEach((element) {
      if (element != null) {
        element(payload);
      }
    });
  }

  void on(String event, Function callback) {
    if (listeners[event] == null) {
      listeners[event] = [];
    }
    listeners[event]!.add(callback);
  }

  void off(String event, Function(dynamic) callback) {
    listeners[event]?.removeWhere((cb) => cb == callback);
  }

  bool get connected => _channel?.closeCode == null;

  bool send(String event, [dynamic payload]) {
    if (connected) {
      _channel?.sink
          .add(jsonEncode(payload != null ? [event, payload] : [event]));
      return true;
    }
    return false;
  }

  bool createRoom() {
    return send('create');
  }

  bool joinRoom(String groupId) {
    return send('join', groupId);
  }

  bool leaveRoom() {
    return send('leave');
  }

  disconnect() async {
    return await _channel?.sink.close(goingAway);
  }

  connect(String email, String password) async {
    await disconnect();

    _channel = WebSocketChannel.connect(
      Uri.parse(url),
    );

    _channel?.stream.listen((dynamic message) {
      // Expecting an array here of size 1 or 2
      final list = jsonDecode(message);
      if (list is List && list.isNotEmpty) {
        final event = list[0];
        if (event is String) {
          final payload = list.length > 1 ? list[1] : null;
          // Debug
          print('[EVENT] ${event} ${payload}');
          _emit(event, payload);
        }
      }
    }, onDone: () {
      // Connection closed by server
      _emit("close");
    }, onError: (error) {
      print('ws error $error');
      _emit("error", error);
    });
  }
}
