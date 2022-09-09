part of 'global_bloc.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();
}

class ConnectionStatusChanged extends GlobalEvent {
  final ConnectionStatus status;

  const ConnectionStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class UserIdChanged extends GlobalEvent {
  final String userId;

  const UserIdChanged(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RoomIdChanged extends GlobalEvent {
  final String roomId;

  const RoomIdChanged(this.roomId);

  @override
  List<Object?> get props => [roomId];
}
