import 'package:flutter/material.dart';
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
    return CollapseModel(
      isCollapsed: false,
      child: Scaffold(
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
      ),
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
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder: (context, index) => TaskTile(index: index),
        ),
      ),
    ));
  }
}

class TaskTile extends StatelessWidget {
  final int index;
  const TaskTile({super.key, required this.index});

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
        title: const Text('Купить что-то'),
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
    final model = context.dependOnInheritedWidgetOfExactType<CollapseModel>();
    final isCollapsed = model?.isCollapsed ?? false;

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
                  subtitle: const Text('Выполнено – 5'),
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
