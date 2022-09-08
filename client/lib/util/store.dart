import 'package:flutter/material.dart';
import 'package:flutter_feasibility/util/event.dart';

class Store extends ChangeNotifier {
  String? _userId;
  String? _email;
  String? _roomId;
  String? _token;
  final ObservableSet<String> _members = ObservableSet<String>();

  ObservableSet<String> get members => _members;

  bool get loggedIn => _token?.isNotEmpty ?? false;

  bool get insideRoom => _roomId?.isNotEmpty ?? false;

  void reset() {
    _userId = null;
    _email = null;
    _roomId = null;
    _token = null;
    _members.clear();
    notifyListeners();
  }

  set token(String? token) {
    _token = token;
    notifyListeners();
  }

  String? get token => _token;

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  String? get userId => _userId;

  set email(String? email) {
    _email = email;
    notifyListeners();
  }

  String? get email => _email;

  set roomId(String? roomId) {
    _roomId = roomId;
    notifyListeners();
  }

  String? get roomId => _roomId;
}
