import 'package:flutter/material.dart' hide Checkbox;
import 'package:vaipoing_test/customized_widgets/checkbox_painter.dart';

class CustomCheckbox extends StatefulWidget {
  final bool? value;
  final Duration? duration;
  final Function(bool) onTap;
  final Color color;

  ///
  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.duration,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: widget.color,
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
