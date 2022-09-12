part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();
}

class MemberAddedEvent extends MembersEvent {
  final Member member;
  const MemberAddedEvent(this.member);

  @override
  List<Object?> get props => [member];
}


class MemberChangedEvent extends MembersEvent {
  final Member member;
  const MemberChangedEvent(this.member);

  @override
  List<Object?> get props => [member];
}


class MemberRemovedEvent extends MembersEvent {
  final Member member;
  const MemberRemovedEvent(this.member);

  @override
  List<Object?> get props => [member];
}