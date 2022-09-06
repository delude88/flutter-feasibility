import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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

  dynamic toJson() => payload ? [event, payload] : [event];
}

Event? parseEvent(dynamic data) {
  final List list = jsonDecode(data);
  if (list.isNotEmpty) {
    return Event(list[0], list.length > 1 ? list[1] : null);
  }
  return null;
}

class Store extends ChangeNotifier {
  WebSocketChannel? _channel;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  String? _uid;
  String? _email;
  String? _token;
  String? _groupId;
  final MembersList members = MembersList();

  String? get email => _email;

  String? get uid => _uid;

  String? get groupId => _groupId;

  String? get token => _token;

  bool get loggedIn => _token?.isNotEmpty ?? false;

  bool get insideRoom => loggedIn && groupId != null;

  ConnectionStatus get connectionStatus => _connectionStatus;

  join(String groupId) {
    _channel?.sink.add(Event('join', groupId));
  }

  leave(String groupId) {
    _channel?.sink.add(Event('leave'));
  }

  sendSessionDescription(String to, dynamic sdp) {
    _channel?.sink
        .add(Event('sdp', jsonEncode({"to": to, "from": _uid, "sdp": sdp})));
  }

  connect(String url, String email, String password) {
    disconnect();
    _connectionStatus = ConnectionStatus.connecting;
    notifyListeners();
    _email = email;
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
    _connectionStatus = ConnectionStatus.connected;
    notifyListeners();
    _channel?.stream.listen((message) {
      final event = parseEvent(message);
      if (event != null) {
        switch (event.event) {
          case "uid":
            {
              _uid = event.payload;
              _token = _uid;
              notifyListeners();
            }
            break;
          case "joined":
            {
              _groupId = event.payload;
              print("JOINED!!!!");
              notifyListeners();
            }
            break;
          case "user-added":
            {
              members.add(event.payload);
            }
            break;
          case "user-removed":
            {
              members.remove(event.payload);
            }
            break;
          case "left":
            {
              members.clear();
              _groupId = null;
              notifyListeners();
            }
            break;
          case "sdp":
            {
              final sdp = SDP.fromJson(event.payload);
              if (_groupId != null && members.list.contains(sdp.from)) {
                // Ok, SDP seems valid
                //TODO
              }
            }
            break;
        }
      }
    });
  }

  disconnect() {
    _email = null;
    _token = null;
    _channel?.sink.close(status.goingAway);
    _connectionStatus = ConnectionStatus.disconnected;
    notifyListeners();
  }
}

class MembersList extends ChangeNotifier {
  final Set<String> _list = HashSet<String>();

  UnmodifiableSetView<String> get list => UnmodifiableSetView(_list);

  void add(String memberId) {
    _list.add(memberId);
    notifyListeners();
  }

  void remove(String memberId) {
    _list.removeWhere((id) => id == memberId);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}