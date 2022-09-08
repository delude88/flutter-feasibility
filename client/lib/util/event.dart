import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

enum ListAction { added, removed }

class ListEvent<T> {
  final T item;
  final ListAction action;
  final UnmodifiableListView<T> list;

  ListEvent(this.item, this.action, this.list);
}

class ObservableSet<T> extends ChangeNotifier {
  final Set<T> _set = HashSet<T>();
  final StreamController<ListEvent<T>> _eventStream =
      StreamController<ListEvent<T>>.broadcast();

  UnmodifiableSetView<T> get set => UnmodifiableSetView(_set);

  Stream<ListEvent<T>> get stream => _eventStream.stream;

  bool add(T item) {
    if (_set.add(item)) {
      _eventStream.add(
          ListEvent<T>(item, ListAction.added, UnmodifiableListView(_set)));
      notifyListeners();
      return true;
    }
    return false;
  }

  void clear() {
    for (var item in _set.toSet()) {
      remove(item);
    }
  }

  bool remove(T item) {
    if (_set.remove(item)) {
      _eventStream.add(
          ListEvent<T>(item, ListAction.removed, UnmodifiableListView(_set)));
      notifyListeners();
      return true;
    }
    return false;
  }
}

class ObservableList<T> extends ChangeNotifier {
  final List<T> _list = [];
  final _eventStream = StreamController<ListEvent<T>>.broadcast();

  UnmodifiableListView<T> get list => UnmodifiableListView(_list);

  Stream<ListEvent<T>> get stream => _eventStream.stream;

  void add(T item) {
    _list.add(item);
    _eventStream
        .add(ListEvent<T>(item, ListAction.added, UnmodifiableListView(_list)));
    notifyListeners();
  }

  void clear() {
    for (var item in _list) {
      remove(item);
    }
  }

  void removeAt(int index) {
    final retVal = _list.removeAt(index);
    _eventStream.add(
        ListEvent<T>(retVal, ListAction.removed, UnmodifiableListView(_list)));
  }

  void remove(T item) {
    _list.removeWhere((element) => element == item);
    _eventStream.add(
        ListEvent<T>(item, ListAction.removed, UnmodifiableListView(_list)));
    notifyListeners();
  }
}
