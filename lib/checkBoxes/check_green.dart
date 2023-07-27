import 'package:flutter/material.dart' hide Checkbox;
import 'package:vaipoing_test/checkbox.dart';

class CheckboxGreen extends StatefulWidget {
  final bool? value;
  final Duration? duration;
  final Function(bool) onTap;

  ///
  const CheckboxGreen({
    Key? key,
    required this.value,
    required this.duration,
    required this.onTap,
  }) : super(key: key);

  @override
  CheckboxGreenState createState() => CheckboxGreenState();
}

class CheckboxGreenState extends State<CheckboxGreen> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      hoverColor: Colors.green,
      activeColor: Colors.green,
      focusColor: Colors.green,
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
