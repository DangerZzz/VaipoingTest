import 'package:flutter/material.dart' hide Checkbox;
import 'package:vaipoing_test/customized_widgets/checkbox.dart';

class CheckboxRed extends StatefulWidget {
  final bool? value;
  final Duration? duration;
  final Function(bool) onTap;

  ///
  const CheckboxRed({
    Key? key,
    required this.value,
    required this.onTap,
    required this.duration,
  }) : super(key: key);

  @override
  CheckboxRedState createState() => CheckboxRedState();
}

class CheckboxRedState extends State<CheckboxRed> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      hoverColor: Colors.red,
      activeColor: Colors.red,
      focusColor: Colors.red,
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
