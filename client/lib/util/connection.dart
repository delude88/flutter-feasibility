import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'store.dart';

const url = 'ws://localhost:3000';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
}

class SDP {
  final String to;
  final String from;
  final dynamic sdp;

  SDP(this.to, this.from, this.sdp);

  SDP.fromJson(Map<String, dynamic> json)
      : to = json['to'],
        from = json['from'],
        sdp = json['sdp'];

  Map<String, dynamic> toJson() => {
        'to': to,
        'from': from,
        'sdp': sdp,
      };
}

class Event {
  final String event;
  final dynamic payload;

  Event(this.event, [this.payload]);

  @override
  String toString() {
    if (payload != null) {
      return jsonEncode([event, payload]);
    }
    return jsonEncode([event]);
  }
}

Event? parseEvent(dynamic data) {
  final List list = jsonDecode(data);
  if (list.isNotEmpty) {
    return Event(list[0], list.length > 1 ? list[1] : null);
  }
  return null;
}

class Connection extends ChangeNotifier {
  final Store _store;
  final _sdpStream = StreamController<SDP>();

  WebSocketChannel? _channel;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  Store get store => _store;

  Stream<SDP> get sdpStream => _sdpStream.stream;

  Connection(this._store);

  ConnectionStatus get connectionStatus => _connectionStatus;

  _send(Event event) {
    _channel?.sink.add(event.toString());
  }

  create() {
    _send(Event('create'));
  }

  join(String groupId) {
    _send(Event('join', groupId));
  }

  leave() {
    _send(Event('leave'));
  }

  sendSessionDescription(String to, dynamic sdp) {
    assert(_store.userId != null);
    _channel?.sink.add(Event(
        'sdp', jsonEncode({"to": to, "from": _store.userId, "sdp": sdp})));
  }

  connect(String email, String password) {
    disconnect();

    _connectionStatus = ConnectionStatus.connecting;
    notifyListeners();

    _store.email = email;
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
    _connectionStatus = ConnectionStatus.connected;
    notifyListeners();

    _channel?.stream.listen((dynamic message) {
      final event = parseEvent(message);
      if (event != null) {
        if (event.payload != null) {
          print('[WS] ${event.event}: ${event.payload}');
        } else {
          print('[WS] ${event.event}');
        }
        switch (event.event) {
          case "uid":
            {
              _store.userId = event.payload;
              _store.token = _store
                  .userId; // <-- TODO: Replace with real JWT implementation
            }
            break;
          case "joined":
            {
              _store.roomId = event.payload;
            }
            break;
          case "user-added":
            {
              _store.members.add(event.payload);
            }
            break;
          case "user-removed":
            {
              _store.members.remove(event.payload);
            }
            break;
          case "left":
            {
              _store.members.clear();
              _store.roomId = null;
            }
            break;
          case "sdp":
            {
              final sdp = SDP.fromJson(event.payload);
              _sdpStream.add(sdp);
            }
            break;
        }
      }
    }, onDone: () {
      // Connection closed by server
      _connectionStatus = ConnectionStatus.disconnected;
      notifyListeners();
      _store.reset();
    }, onError: (error) {
      print('ws error $error');
    });
  }

  disconnect() async {
    await _channel?.sink.close(goingAway);
  }
}
