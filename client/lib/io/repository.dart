import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnectionStatus { disconnected, connecting, connected }

class Event {
  final String event;
  final dynamic payload;

  Event(this.event, [this.payload]);
}

class Repository {
  final String _url;
  WebSocketChannel? _channel;
  final _streamController = StreamController<Event>.broadcast();
  final _statusStreamController = StreamController<ConnectionStatus>.broadcast();

  Repository(this._url);

  Stream<Event> get events async* {
    yield* _streamController.stream;
  }

  Stream<ConnectionStatus> get status async* {
    yield ConnectionStatus.disconnected;
    yield* _statusStreamController.stream;
  }

  bool get connected => _channel?.closeCode == null;

  void send(String event, [dynamic payload]) {
    print('[SEND EVENT] $event $payload');
    _channel?.sink
        .add(jsonEncode(payload != null ? [event, payload] : [event]));
  }

  disconnect() async {
    return await _channel?.sink.close(goingAway);
  }

  connect(String email, String password) async {
    await disconnect();

    _statusStreamController.add(ConnectionStatus.connecting);
    _channel = WebSocketChannel.connect(
      Uri.parse(_url),
    );
    _statusStreamController.add(ConnectionStatus.connected);

    _channel?.stream.listen((dynamic message) {
      // Expecting an array here of size 1 or 2
      final list = jsonDecode(message);
      if (list is List && list.isNotEmpty) {
        final event = list[0];
        if (event is String) {
          final payload = list.length > 1 ? list[1] : null;
          // Debug
          print('[RCVD EVENT] $event $payload');
          _streamController.sink.add(Event(event, payload));
        }
      }
    }, onDone: () {
      // Connection closed by server
      _streamController.sink.add(Event('close'));
      _statusStreamController.add(ConnectionStatus.disconnected);
    }, onError: (error) {
      print('ws error $error');
      _streamController.sink.add(Event('error', error));
    });
  }

  void createRoom() {
     send('create');
  }

  void joinRoom(String groupId) {
     send('join', groupId);
  }

  void leaveRoom() {
     send('leave');
  }

  void dispose() {
    disconnect();
    _statusStreamController.close();
    _streamController.close();
  }
}
