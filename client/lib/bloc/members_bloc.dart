import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_feasibility/io/repository.dart';
import 'package:flutter_feasibility/model/member.dart';
import 'package:flutter_feasibility/services/webrtc_service.dart';

part 'members_event.dart';

part 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final Repository repository;
  WebRTCService? _mediaService;

  MembersBloc(this.repository) : super(MembersInitial()) {
    on<MemberAddedEvent>((event, emit) {
      emit(MembersState(HashSet.from([...state.members, event.member])));
    });
    on<MemberChangedEvent>((event, emit) {
      // TODO: Is this necessary?!? Only the item has changed ...
      //emit(MembersState(HashSet.from([...state.members])));
    });
    on<MemberRemovedEvent>((event, emit) {
      final Set<Member> set = HashSet.from(state.members);
      set.remove(event.member);
      emit(MembersState(set));
    });

    repository.status.listen((event) {
      if (event == ConnectionStatus.disconnected) {
        _mediaService?.close();
      }
    });
    repository.events.listen((event) async {
      if (event.event == "uid") {
        print("Creating WEBRTC service");
        final mediaService = WebRTCServiceImpl(repository, event.payload);
        _mediaService = mediaService;
        for (final element in state.members) {
          //TODO: Async error handling
          mediaService.addPeer(element.id);
        }
        return;
      }
      if (event.event == "user-added") {
        final id = event.payload as String;
        _mediaService?.addPeer(id);
        return add(MemberAddedEvent(Member(id, id)));
      }
      if (event.event == "user-removed") {
        final id = event.payload as String;
        _mediaService?.removePeer(id);
        try {
          final element =
              state.members.firstWhere((element) => element.id == id);
          return add(MemberRemovedEvent(element));
        } catch (_) {
          // Nothing to do here, handling firstWhere
          return;
        }
      }
      if (event.event == 'left') {
        for (final element in state.members) {
          _mediaService?.removePeer(element.id);
          add(MemberRemovedEvent(element));
        }
        return;
      }
    });
  }
}
