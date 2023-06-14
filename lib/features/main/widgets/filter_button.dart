import 'package:flutter/material.dart';

import '../state.dart';

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
