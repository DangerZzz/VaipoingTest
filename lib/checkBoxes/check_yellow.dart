import 'package:flutter/material.dart' hide Checkbox;
import 'package:vaipoing_test/checkbox.dart';

class CheckboxYellow extends StatefulWidget {
  final bool? value;
  final Duration? duration;
  final Function(bool) onTap;

  ///
  const CheckboxYellow({
    Key? key,
    required this.value,
    required this.onTap,
    required this.duration,
  }) : super(key: key);

  @override
  CheckboxYellowState createState() => CheckboxYellowState();
}

class CheckboxYellowState extends State<CheckboxYellow> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      hoverColor: Colors.orangeAccent,
      activeColor: Colors.orangeAccent,
      focusColor: Colors.orangeAccent,
      duration: widget.duration!,
      value: widget.value,
      onChanged: (state) {
        setState(() {
          widget.onTap(state!);
        });
      },
    );
  }
}
