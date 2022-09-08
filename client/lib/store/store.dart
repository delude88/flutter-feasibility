import 'eventor.dart';
import 'global.dart';
import 'member_list.dart';

class Store {
  final Eventor eventor;
  final Global global;
  final MemberList memberList;

  Store(this.eventor)
      : global = Global(eventor),
        memberList = MemberList(eventor);
}
