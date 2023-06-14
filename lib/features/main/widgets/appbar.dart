import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';

import '../state.dart';
import 'filter_button.dart';

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
