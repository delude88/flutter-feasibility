part of 'members_bloc.dart';

class MembersState extends Equatable {
  final Set<Member> members;

  const MembersState(this.members);

  @override
  List<Object> get props => [members];
}

class MembersInitial extends MembersState {
  MembersInitial() : super(HashSet());
}
