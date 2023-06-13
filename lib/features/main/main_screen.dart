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
      body: NotificationListener<CollapseNotification>(
          onNotification: (notification) {
            setState(() {
              isCollapsed = notification.isCollapsed;
            });
            return true;
          },
          child: CollapseModel(
              isCollapsed: isCollapsed, child: const MainScrollView())),
    );
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
    final data = DataModel.maybeOf(context);
    assert(data != null);
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListenableBuilder(
          listenable: data!,
          builder: (context, child) => ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.tasks.length,
            itemBuilder: (context, index) {
              final t = data.tasks.keys.elementAt(index);
              return TaskTile(
                index: t,
                task: data.tasks[t]!,
              );
            },
          ),
        ),
      ),
    ));
  }
}

class TaskTile extends StatelessWidget {
  final int index;
  final TaskModel task;
  const TaskTile({super.key, required this.index, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
      key: ValueKey(index),
      child: ListTile(
        leading: Checkbox(value: false, onChanged: (value) {}),
        title: Text(task.text),
        trailing: IconButton(
            onPressed: () {}, icon: const Icon(Icons.info_outline_rounded)),
      ),
    );
  }
}

class CollapsibleAppBar extends StatelessWidget {
  const CollapsibleAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final collapseModel =
        context.dependOnInheritedWidgetOfExactType<CollapseModel>();
    final isCollapsed = collapseModel?.isCollapsed ?? false;

    final dataModel = DataModel.maybeOf(context);
    assert(dataModel != null);
    final completed = dataModel!.tasks.values.where((t) => t.completed).length;

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
          child: isCollapsed
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.visibility_rounded,
                    color: Colors.blue,
                  ))
              : null,
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
                  trailing: const Icon(
                    Icons.visibility_rounded,
                    color: Colors.blue,
                  ),
                ),
        ),
      ),
    );
  }
}
