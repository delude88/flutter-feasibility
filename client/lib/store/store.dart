import 'package:flutter_feasibility/io/socket_connection.dart';

import 'global.dart';
import 'member_list.dart';

class Store {
  final SocketConnection repository;
  final Global global;
  final MemberList memberList;

  Store(this.repository)
      : global = Global(repository),
        memberList = MemberList(repository);
}
