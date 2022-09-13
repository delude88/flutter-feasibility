import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_feasibility/io/socket_connection.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final SocketConnection repository;
  late StreamSubscription<ConnectionStatus> _connectionStatusListener;
  late StreamSubscription<Event> _eventListener;

  GlobalBloc(this.repository) : super(const GlobalInitial()) {
    on<ConnectionStatusChanged>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
    on<UserIdChanged>((event, emit) {
      emit(state.copyWith(userId: event.userId));
    });
    on<RoomIdChanged>((event, emit) {
      emit(state.copyWith(roomId: event.roomId));
    });
    _connectionStatusListener = repository.status.listen((status) {
      add(ConnectionStatusChanged(status));
      if (status == ConnectionStatus.disconnected) {
        add(const UserIdChanged(""));
        add(const RoomIdChanged(""));
      }
    });

    _eventListener = repository.events.listen((event) {
      if (event.event == "joined") {
        return add(RoomIdChanged(event.payload));
      }
      if (event.event == "left") {
        return add(const RoomIdChanged(""));
      }
      if (event.event == "uid") {
        return add(const UserIdChanged(""));
      }
    });
  }

  @override
  Future<void> close() {
    _connectionStatusListener.cancel();
    _eventListener.cancel();
    repository.disconnect();
    return super.close();
  }
}
