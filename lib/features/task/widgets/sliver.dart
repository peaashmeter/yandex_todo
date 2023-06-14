import 'package:flutter/material.dart';
import 'package:yandex_todo/features/task/widgets/task_text.dart';

import 'date_tile.dart';
import 'delete_button.dart';
import 'importance.dart';

class TaskEditSliver extends StatelessWidget {
  const TaskEditSliver({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskTextField(),
            ImportanceTile(),
            Divider(),
            DateTile(),
            Divider(),
            DeleteButton()
          ],
        ),
      ),
    );
  }
}
