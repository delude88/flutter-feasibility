import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_feasibility/io/repository.dart';

part 'members_event.dart';

part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final Repository respository;

  MembersBloc(this.respository) : super(MembersInitial()) {
    on<MemberAddedEvent>((event, emit) {
      emit(MembersState(HashSet.from([...state.members, event.member])));
    });
    on<MemberRemovedEvent>((event, emit) {
      final Set<String> set = HashSet.from(state.members);
      set.remove(event.member);
      emit(MembersState(set));
    });

    respository.events.listen((event) {
      if (event.event == "user-added") {
        return add(MemberAddedEvent(event.payload));
      }
      if (event.event == "user-removed") {
        return add(MemberRemovedEvent(event.payload));
      }
      if (event.event == 'left') {
        for (var element in state.members) {
          add(MemberRemovedEvent(element));
        }
        return;
      }
    });
  }
}
