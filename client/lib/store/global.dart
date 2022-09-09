import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_feasibility/io/repository.dart';


class Global with ChangeNotifier {
  final Repository _repository;
  late StreamSubscription<Event> _listener;
  String? _userId;
  String? _roomId;

  Global(this._repository) {
    _listener = _repository.events.where((event) => event.event == 'uid').listen((event) {
      if(event.event == 'uid') {
        _userId = event.payload;
        return notifyListeners();
      }
      if(event.event == 'joined') {
        _roomId = event.payload;
        return notifyListeners();
      }
      if(event.event == 'left') {
        _roomId = null;
        return notifyListeners();
      }
      if(event.event == 'close') {
        _userId = null;
        _roomId = null;
        return notifyListeners();
      }
    });
    //TODO: CLOSE stream?!?
  }

  bool get loggedIn => _userId?.isNotEmpty ?? false;

  bool get insideRoom => _roomId?.isNotEmpty ?? false;

  String? get userId => _userId;

  String? get roomId => _roomId;
}
