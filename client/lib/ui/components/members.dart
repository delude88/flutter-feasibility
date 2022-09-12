import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feasibility/bloc/members_bloc.dart';
import 'package:flutter_feasibility/model/member.dart';

class Members extends StatelessWidget {
  const Members({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        final List<Member> list = state.members.toList();
        return Column(
          children: [
            Text("Hey ${list.length} people"),
            list.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        ListTile(title: Text('Member ${list[index].name}')),
                  )
                : const Center(child: Text('No members'))
          ],
        );
      },
    );
  }
}
