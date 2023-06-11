import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [TaskAppBar(), TaskEditSliver()],
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
    return SliverAppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close)),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              'СОХРАНИТЬ',
              style: Theme.of(context).textTheme.labelLarge,
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
    return TextButton.icon(
        onPressed: () {},
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
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(
          'Сделать до',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: const Text(
          '2 июня 2021',
          style: TextStyle(color: Colors.blue),
        ),
        value: isActive,
        onChanged: (value) {
          setState(() {
            isActive = value;
          });
        });
  }
}

class ImportanceTile extends StatelessWidget {
  const ImportanceTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Важность',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: const Text('Нет'),
    );
  }
}

class TaskTextField extends StatelessWidget {
  const TaskTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: const TextField(
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
