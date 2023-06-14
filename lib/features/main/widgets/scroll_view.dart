import 'package:flutter/material.dart';

import '../state.dart';
import 'appbar.dart';
import 'task_list.dart';

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
