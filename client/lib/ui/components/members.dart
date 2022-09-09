import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feasibility/bloc/members_bloc.dart';

class Members extends StatelessWidget {
  const Members({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        final List<String> list = state.members.toList();
        return Column(
          children: [
            Text("Hey ${list.length} people"),
            list.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('Member ${list[index]}')),
            )
                : const Center(child: Text('No members'))
          ],
        );
      },
    );
  }
}
