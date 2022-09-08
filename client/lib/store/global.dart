import 'package:flutter/foundation.dart';

import 'eventor.dart';

class Global with ChangeNotifier {
  final Eventor _eventSource;
  String? _userId;
  String? _roomId;

  Global(this._eventSource) {
    _eventSource.on("uid", (userId) {
      _userId = userId;
      notifyListeners();
    });
    _eventSource.on("joined", (roomId) {
      _roomId = roomId;
      notifyListeners();
    });
    _eventSource.on("left", () {
      _roomId = null;
      notifyListeners();
    });
  }

  bool get loggedIn => _userId?.isNotEmpty ?? false;

  bool get insideRoom => _roomId?.isNotEmpty ?? false;

  String? get userId => _userId;

  String? get roomId => _roomId;
}
