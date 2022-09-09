part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();
}

class MemberAddedEvent extends MembersEvent {
  final String member;
  const MemberAddedEvent(this.member);

  @override
  List<Object?> get props => [member];
}


class MemberRemovedEvent extends MembersEvent {
  final String member;
  const MemberRemovedEvent(this.member);

  @override
  List<Object?> get props => [member];
}