import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_feasibility/io/socket_connection.dart';

class MemberList with ChangeNotifier {
  final SocketConnection _repository;
  late StreamSubscription<Event> _listener;
  final Set<String> _set = HashSet<String>();

  UnmodifiableListView<String> get list => UnmodifiableListView<String>(_set);

  MemberList(this._repository) {
    _listener = _repository.events.listen((event) {
      if (event.event == 'left') {
        _set.clear();
        return notifyListeners();
      }
      if (event.event == 'user-added') {
        _set.add(event.payload);
        return notifyListeners();
      }
      if (event.event == 'user-removed') {
        _set.removeWhere((member) => member == event.payload);
        return notifyListeners();
      }
    });
    // TODO: CLOSE stream!!!
  }
}
