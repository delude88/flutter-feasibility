import 'package:flutter/foundation.dart';

import 'eventor.dart';

class MemberList with ChangeNotifier {
  final List<String> members = [];
  final Eventor _eventSource;

  MemberList(this._eventSource) {
    // Listen to specific events
    _eventSource.on("left", (userId) {
      members.clear();
      notifyListeners();
    });
    _eventSource.on("user-added", (member) {
      members.add(member);
      notifyListeners();
    });
    _eventSource.on("user-removed", (member) {
      members.removeWhere((curr) => curr == member);
      notifyListeners();
    });
  }
}
