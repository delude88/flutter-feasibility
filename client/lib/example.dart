import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

Future<void> runExample() async {
  print("runExample");
  final cubit = ExampleCubit();
  // Setup cubit
  cubit.add(const Item("1", [SubItem("Bla"), SubItem("Blubb")]));
  cubit.add(const Item("2", [SubItem("Schnurr"), SubItem("Miau")]));
  cubit.add(const Item("3", [SubItem("Wau"), SubItem("Wuff")]));
  cubit.performExternalEmit();
  return await Future.delayed(const Duration(seconds: 10));
}

class ItemRepository {
  final List<Item> items = [];
  bool _running = false;

  void run() {
    if (!_running) {
      _onItemAdded(Item("Bla", [SubItem("First"), SubItem("Second")]));
      _onItemAdded(Item("Blubb", [SubItem("Third"), SubItem("Fourth")]));
      _onItemAdded(Item("Hey", [SubItem("Sixth"), SubItem("Seventh")]));
      final random = Random();
      Timer(const Duration(seconds: 2), () {
        // Change item
        if (items.length > 0) {
          // Pick some item
          final item = items[random.nextInt(items.length)];
          //final item = Item(formerItem.id, formerItem.list);
          item.list.add(SubItem("Blablabla"));
          item.list.removeLast();
        }
      });
    }
  }

  void _onItemAdded(Item item) {}

  void _onItemChanged(Item item) {
    // Item with item.id changed
  }

  void _onItemRemoved(Item item) {}
}

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

class SubItem extends Equatable {
  final String content;

  const SubItem(this.content);

  @override
  List<Object?> get props => [content];
}

class Item extends Equatable {
  final String id;
  final List<SubItem> list;

  const Item(this.id, this.list);

  @override
  List<Object?> get props => [id, list];
}

class ExampleState extends Equatable {
  final List<Item> list;

  const ExampleState(this.list);

  @override
  List<Object> get props => [list];
}

class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(const ExampleState([]));

  void add(Item item) {
    emit(ExampleState([...state.list, item]));
  }

  void performExternalEmit() {
    print("Performing external emit in 2 seconds");
    Future.delayed(const Duration(seconds: 2), () {
      print("Performing external emit now");
      // Two seconds later ... the last inner item is changed
      // Use item of last element

      // WTF? THIS IS JUST A MESS ... THERE HAS TO BE ANOTHER SOLUTION ...
      final id = state.list.last.id;
      final list = [
        ...state.list
            .map((item) => item.id == id ? Item(item.id, [...item.list]) : item)
      ];
      emit(ExampleState(list));
    });
  }

  void remove(String id) {
    emit(ExampleState([...state.list.where((element) => element.id != id)]));
  }
}
