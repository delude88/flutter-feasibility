import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_feasibility/io/socket_connection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {}

class Member extends Equatable {
  final String id;
  final String name;
  final List<MediaStream> mediaStreams;
  final List<RTCDataChannel> dataChannels;

  const Member(this.id, this.name, this.mediaStreams, this.dataChannels);

  @override
  List<Object?> get props => [id, name];
}

class Room extends Equatable {
  final String id;
  final String name;
  final List<Member> members;

  const Room(this.id, this.name, this.members);

  @override
  List<Object?> get props => [id, name, members];
}

enum RepositoryStatus { initial, connecting, connected, disconnected }

abstract class Repository {
  RepositoryStatus get status;

  void createRoom();

  void joinRoom(String groupId);

  void leaveRoom();

  Future<void> connect(String email, String password);

  Future<void> disconnect();
}

class RepositoryImpl implements Repository {
  final SocketConnection _socket;
  RepositoryStatus _status;

  RepositoryImpl(this._socket) : _status = RepositoryStatus.initial;

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> connect(String email, String password) {
    return _socket.connect(email, password);
  }

  @override
  void createRoom() {
    // TODO: implement createRoom
  }

  @override
  void joinRoom(String groupId) {
    // TODO: implement joinRoom
  }

  @override
  void leaveRoom() {
    // TODO: implement leaveRoom
  }

  @override
  // TODO: implement status
  RepositoryStatus get status => throw UnimplementedError();

  @override
  Future<void> disconnect() {
    return _socket.disconnect();
  }
}

/// MEMBER LIST
// Status
enum RoomStatus { initial, loading, success, failure }

class RoomState extends Equatable {
  final RoomStatus status;
  final Room? room;
  final Exception? exception;

  const RoomState(
      {this.status = RoomStatus.initial, this.room, this.exception});

  RoomState copyWith({
    RoomStatus? status,
    Room? room,
    Exception? exception,
  }) {
    return RoomState(
      status: status ?? this.status,
      room: room ?? this.room,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, room, exception];
}

class RoomCubit extends Cubit<RoomState> {
  final Repository repository;

  RoomCubit(this.repository) : super(const RoomState());
}

class MemberState {
  final Member? member;

  MemberState(this.member);
}

class MemberCubit extends Cubit<MemberState> {
  final Repository repository;
  final String id;

  MemberCubit(this.id, this.repository) : super(MemberState(null)) {}

  @override
  Future<void> close() {
    return super.close();
  }
}
