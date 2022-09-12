import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String name;

  const Member(this.id, this.name);

  @override
  List<Object?> get props => [id];
}
