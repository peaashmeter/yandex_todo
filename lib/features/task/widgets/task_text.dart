import 'package:flutter/material.dart';

import '../task_model.dart';

class TaskTextField extends StatelessWidget {
  const TaskTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final text = TaskModel.of(context).task.text;

    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: TextFormField(
        initialValue: text,
        onChanged: (value) => _bubbleNotification(value, context),
        minLines: 5,
        maxLines: null,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  _bubbleNotification(String t, BuildContext context) {
    UpdateTaskNotification(t).dispatch(context);
  }
}
