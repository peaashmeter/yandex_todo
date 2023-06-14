import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/features/task/task_model.dart';
import 'package:yandex_todo/features/task/task_screen.dart';

import 'state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isCollapsed = false;
  bool showCompleted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TaskScreen(),
          ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: NotificationListener(
          onNotification: (notification) => switch (notification) {
                CollapseNotification n => _onCollapseNotification(n),
                SwitchFilterNotification n => _onSwitchFilterNotification(n),
                _ => false
              },
          child: MainScreenModel(
              isCollapsed: isCollapsed,
              showCompleted: showCompleted,
              child: const MainScrollView())),
    );
  }

  bool _onCollapseNotification(CollapseNotification notification) {
    setState(() {
      isCollapsed = notification.isCollapsed;
    });
    return true;
  }

  bool _onSwitchFilterNotification(SwitchFilterNotification notification) {
    setState(() {
      showCompleted = notification.showCompleted;
    });
    return true;
  }
}

class MainScrollView extends StatefulWidget {
  const MainScrollView({
    super.key,
  });

  @override
  State<MainScrollView> createState() => _MainScrollViewState();
}

class _MainScrollViewState extends State<MainScrollView> with ChangeNotifier {
  bool isCollapsed = false;
  final controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      final newIsCollapsed = controller.offset > 0;
      if (newIsCollapsed != isCollapsed) {
        CollapseNotification(newIsCollapsed).dispatch(context);
      }
      isCollapsed = newIsCollapsed;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: const [CollapsibleAppBar(), MainTaskList()],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

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
        mainScreenModel!.showCompleted ? null : (TaskModel t) => !t.completed;

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

class TaskTile extends StatelessWidget {
  final int id;
  final TaskModel task;
  const TaskTile({super.key, required this.id, required this.task});

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context);
    assert(dataModel != null);

    return Dismissible(
      onDismissed: (direction) => _deleteTask(context),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _markAsCompleted(context);
          return false;
        }
        return true;
      },
      background: Container(
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft, child: Icon(Icons.done_rounded)),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_rounded)),
        ),
      ),
      key: ValueKey(id),
      child: ListTile(
        leading: Checkbox(
            value: dataModel!.getTasks()[id]?.completed,
            onChanged: (value) => _markAsCompleted(context)),
        title: Text(task.text),
        trailing: IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TaskScreen.edit(id),
                )),
            icon: const Icon(Icons.info_outline_rounded)),
      ),
    );
  }

  _deleteTask(BuildContext context) =>
      DataModel.maybeOf(context)?.removeTask(id);
  _markAsCompleted(BuildContext context) =>
      DataModel.maybeOf(context)?.completeTask(id);
}

class CollapsibleAppBar extends StatelessWidget {
  const CollapsibleAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainScreenModel =
        context.dependOnInheritedWidgetOfExactType<MainScreenModel>();
    final isCollapsed = mainScreenModel?.isCollapsed ?? false;

    final dataModel = DataModel.maybeOf(context);
    assert(dataModel != null);
    final completed =
        dataModel!.getTasks().values.where((t) => t.completed).length;

    return SliverAppBar(
      title: AnimatedSwitcher(
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        duration: const Duration(milliseconds: 300),
        child: isCollapsed
            ? Text(
                'Мои дела',
                style: Theme.of(context).textTheme.titleLarge,
              )
            : null,
      ),
      actions: [
        AnimatedSwitcher(
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          duration: const Duration(milliseconds: 300),
          child: isCollapsed ? const SwitchFilterButton() : null,
        ),
      ],
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: AnimatedSwitcher(
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          duration: const Duration(milliseconds: 300),
          child: isCollapsed
              ? null
              : ListTile(
                  title: Text(
                    'Мои дела',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text('Выполнено – $completed'),
                  trailing: const SwitchFilterButton(),
                ),
        ),
      ),
    );
  }
}

class SwitchFilterButton extends StatefulWidget {
  const SwitchFilterButton({
    super.key,
  });

  @override
  State<SwitchFilterButton> createState() => _SwitchFilterButtonState();
}

class _SwitchFilterButtonState extends State<SwitchFilterButton> {
  var showCompleted = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            showCompleted = !showCompleted;
          });
          SwitchFilterNotification(showCompleted).dispatch(context);
        },
        icon: Icon(
          showCompleted
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded,
          color: Colors.blue,
        ));
  }
}
