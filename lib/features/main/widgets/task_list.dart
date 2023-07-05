import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/features/task/task_model.dart';

import '../state.dart';
import 'task_tile.dart';

class MainTaskList extends StatelessWidget {
  const MainTaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainScreenModel =
        context.dependOnInheritedWidgetOfExactType<MainScreenModel>();
    final data = DataModel.maybeOf(context);
    assert(data != null && mainScreenModel != null);

    final predicate =
        mainScreenModel!.showCompleted ? null : (Task t) => !t.done;

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListenableBuilder(
          listenable: data!,
          builder: (context, child) {
            final tasks = data.getTasks(predicate);
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final t = tasks.keys.elementAt(index);
                return TaskTile(
                  id: t,
                  task: tasks[t]!,
                );
              },
            );
          },
        ),
      ),
    ));
  }
}
