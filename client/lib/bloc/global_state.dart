part of 'global_bloc.dart';

class GlobalState extends Equatable {
  final ConnectionStatus status;
  final String userId;
  final String roomId;

  const GlobalState(this.userId, this.roomId, this.status);

  GlobalState copyWith({
    ConnectionStatus? status,
    String? userId,
    String? roomId,
  }) {
    return GlobalState(
      userId ?? this.userId,
      roomId ?? this.roomId,
      status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status, userId, roomId];
}

class GlobalInitial extends GlobalState {
  const GlobalInitial() : super("", "", ConnectionStatus.disconnected);
}
