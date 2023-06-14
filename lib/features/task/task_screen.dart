import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/features/task/task_model.dart';
import 'package:yandex_todo/features/task/util.dart';

class TaskScreen extends StatefulWidget {
  ///Если не null, то мы редактируем существующую задачу
  final int? id;
  const TaskScreen({super.key}) : id = null;
  const TaskScreen.edit(int this.id, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime? due;
  Importance importance = Importance.lowest;
  String text = '';

  @override
  void didChangeDependencies() {
    if (widget.id != null) {
      final ref = DataModel.maybeOf(context)?.getTasks()[widget.id];
      if (ref == null) return;

      due = ref.due;
      importance = ref.importance;
      text = ref.text;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UpdateTaskNotification>(
      onNotification: (notification) {
        setState(() => switch (notification.data) {
              DateTime? d => due = d,
              Importance i => importance = i,
              String t => text = t,
              _ => null
            });
        return true;
      },
      child: TaskModel(
        due: due,
        importance: importance,
        text: text,
        id: widget.id,
        child: const Scaffold(
          body: CustomScrollView(
            slivers: [TaskAppBar(), TaskEditSliver()],
          ),
        ),
      ),
    );
  }
}

class TaskAppBar extends StatelessWidget {
  const TaskAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context);
    final taskModel = TaskModel.of(context);

    assert(dataModel != null);
    return SliverAppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close)),
      actions: [
        TextButton(
            onPressed: () {
              taskModel.id == null
                  ? dataModel!.addTask(
                      DateTime.timestamp().millisecondsSinceEpoch, taskModel)
                  : dataModel!.editTask(taskModel.id!, taskModel);
              Navigator.pop(context);
            },
            child: Text(
              'СОХРАНИТЬ',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).primaryColor),
            )),
      ],
      pinned: true,
      floating: true,
    );
  }
}

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

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context)!;
    final id = TaskModel.of(context).id;

    return TextButton.icon(
        onPressed: id == null
            ? null
            : () {
                Navigator.pop(context);
                dataModel.removeTask(id);
              },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        label: const Text(
          'Удалить',
          style: TextStyle(color: Colors.red),
        ));
  }
}

class DateTile extends StatefulWidget {
  const DateTile({
    super.key,
  });

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  late bool isActive;

  @override
  void didChangeDependencies() {
    final due = TaskModel.of(context).due;
    isActive = due != null;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final due = TaskModel.of(context).due;
    return InkWell(
      onTap: () => isActive
          ? showDatePicker(
              context: context,
              initialDate: due ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2077),
            ).then((value) => value != null ? _bubbleNotification(value) : null)
          : null,
      child: ListTile(
        title: Text(
          'Сделать до',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          isActive && due != null ? due.simpleString : '',
          style: const TextStyle(color: Colors.blue),
        ),
        trailing: Switch(
            value: isActive,
            onChanged: (value) {
              setState(() {
                isActive = value;
                if (!value) {
                  _bubbleNotification(null);
                } else {
                  _bubbleNotification(DateTime.now());
                }
              });
            }),
      ),
    );
  }

  _bubbleNotification(DateTime? d) {
    UpdateTaskNotification(d).dispatch(context);
  }
}

class ImportanceTile extends StatefulWidget {
  const ImportanceTile({
    super.key,
  });

  @override
  State<ImportanceTile> createState() => _ImportanceTileState();
}

class _ImportanceTileState extends State<ImportanceTile> {
  @override
  Widget build(BuildContext context) {
    final MenuController controller = MenuController();
    final importance = TaskModel.of(context).importance;

    return InkWell(
      onTap: () => controller.open(),
      child: ListTile(
        title: Text(
          'Важность',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: MenuAnchor(
            controller: controller,
            menuChildren: [
              ImportanceMenuButton(
                importance: Importance.lowest,
                menuContext: context,
              ),
              ImportanceMenuButton(
                importance: Importance.low,
                menuContext: context,
              ),
              ImportanceMenuButton(
                importance: Importance.high,
                menuContext: context,
              ),
            ],
            child: Text(
              importance.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: importance == Importance.high ? Colors.red : null),
            )),
      ),
    );
  }
}

class ImportanceMenuButton extends StatelessWidget {
  final Importance importance;

  ///Нужно для посылки уведомлений в основное дерево виджетов
  final BuildContext menuContext;
  const ImportanceMenuButton(
      {super.key, required this.importance, required this.menuContext});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: () => UpdateTaskNotification(importance).dispatch(menuContext),
      child: Text(importance.text),
    );
  }
}

class TaskTextField extends StatelessWidget {
  const TaskTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final text = TaskModel.of(context).text;

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
