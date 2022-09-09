import 'package:flutter_feasibility/io/repository.dart';

import 'global.dart';
import 'member_list.dart';

class Store {
  final Repository repository;
  final Global global;
  final MemberList memberList;

  Store(this.repository)
      : global = Global(repository),
        memberList = MemberList(repository);
}
