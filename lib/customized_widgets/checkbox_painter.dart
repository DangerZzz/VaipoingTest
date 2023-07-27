import 'package:flutter/material.dart'
    hide ToggleableStateMixin, ToggleablePainter;
import 'package:vaipoing_test/customized_widgets/togable.dart';

/// Измененный класс [Checkbox] из [material.dart]
///
/// Основные изменения:
/// [duration] - новое поле для изменение скорости анимации
/// Добавлены функции [_drawCircle] и [_drawMyCheck] для отрисовки элементов
///
class Checkbox extends StatefulWidget {
  /// The width of a checkbox widget.
  static const double width = 30.0;

  /// Checkbox size
  final double size;

  /// Checkbox animateDuration
  final Duration duration;

  /// Whether this checkbox is checked.
  final bool? value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?>? onChanged;

  ///
  final MouseCursor? mouseCursor;

  ///
  final Color? activeColor;

  ///
  final MaterialStateProperty<Color?>? fillColor;

  ///
  final Color? checkColor;

  ///
  final MaterialTapTargetSize? materialTapTargetSize;

  ///
  final VisualDensity? visualDensity;

  ///
  final Color? focusColor;

  ///
  final Color? hoverColor;

  ///
  final MaterialStateProperty<Color?>? overlayColor;

  ///
  final double? splashRadius;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  ///
  const Checkbox({
    required this.value,
    required this.onChanged,
    required this.duration,
    Key? key,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.size = 30.0,
  }) : super(key: key);

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox>
    with TickerProviderStateMixin, ToggleableStateMixin {
  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _previousDuration = widget.duration;
  }

  final _CheckboxPainter _painter = _CheckboxPainter();

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  bool? _previousValue;

  Duration? _previousDuration;

  MaterialStateProperty<Color?> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final themeData = Theme.of(context);
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return themeData.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return themeData.toggleableActiveColor;
      }
      return themeData.unselectedWidgetColor;
    });
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
    if (oldWidget.duration != widget.duration) {
      _previousDuration = widget.duration;
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final themeData = Theme.of(context);
    final effectiveMaterialTapTargetSize = widget.materialTapTargetSize ??
        themeData.checkboxTheme.materialTapTargetSize ??
        themeData.materialTapTargetSize;
    final effectiveVisualDensity = widget.visualDensity ??
        themeData.checkboxTheme.visualDensity ??
        themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(
          Checkbox.width,
          Checkbox.width,
        );
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;

    final effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>((states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(
            widget.mouseCursor,
            states,
          ) ??
          themeData.checkboxTheme.mouseCursor?.resolve(states) ??
          MaterialStateMouseCursor.clickable.resolve(states);
    });

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final activeStates = states..add(MaterialState.selected);
    final inactiveStates = states..remove(MaterialState.selected);
    final effectiveActiveColor = widget.fillColor?.resolve(activeStates) ??
        _widgetFillColor.resolve(activeStates) ??
        themeData.checkboxTheme.fillColor?.resolve(activeStates) ??
        _defaultFillColor.resolve(activeStates);
    final effectiveInactiveColor = widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        themeData.checkboxTheme.fillColor?.resolve(inactiveStates) ??
        _defaultFillColor.resolve(inactiveStates);

    final focusedStates = states..add(MaterialState.focused);
    final effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
            widget.focusColor ??
            themeData.checkboxTheme.overlayColor?.resolve(focusedStates) ??
            themeData.focusColor;

    final hoveredStates = states..add(MaterialState.hovered);
    final effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
            widget.hoverColor ??
            themeData.checkboxTheme.overlayColor?.resolve(hoveredStates) ??
            themeData.hoverColor;

    final activePressedStates = activeStates..add(MaterialState.pressed);
    final effectiveActivePressedOverlayColor = widget.overlayColor
            ?.resolve(activePressedStates) ??
        themeData.checkboxTheme.overlayColor?.resolve(activePressedStates) ??
        effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final effectiveInactivePressedOverlayColor = widget.overlayColor
            ?.resolve(inactivePressedStates) ??
        themeData.checkboxTheme.overlayColor?.resolve(inactivePressedStates) ??
        effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final effectiveCheckColor = widget.checkColor ?? effectiveActiveColor;

    return Semantics(
      checked: widget.value ?? false,
      child: buildToggleable(
        mouseCursor: effectiveMouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = effectiveInactivePressedOverlayColor
          ..reactionColor = effectiveActivePressedOverlayColor
          ..hoverColor = effectiveHoverOverlayColor
          ..focusColor = effectiveFocusOverlayColor
          ..splashRadius = widget.splashRadius ??
              themeData.checkboxTheme.splashRadius ??
              kRadialReactionRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = effectiveActiveColor
          ..inactiveColor = effectiveInactiveColor
          ..checkColor = effectiveCheckColor
          ..value = value
          ..previousValue = _previousValue
          ..size = widget.size,

        /// Измененное значение
        duration: _previousDuration!,
      ),
    );
  }
}

const double _kStrokeWidth = 1.4;

class _CheckboxPainter extends ToggleablePainter {
  Color get checkColor => _checkColor!;

  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  double get size => _size;

  set size(double value) {
    if (_size == value) {
      return;
    }
    _size = value;
    notifyListeners();
  }

  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;

  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  Duration? get previousDuration => _previousDuration;

  set previousDuration(Duration? value) {
    if (_previousDuration == value) {
      return;
    }
    _previousDuration = value;
    notifyListeners();
  }

  bool? get value => _value;
  Color? _checkColor;
  double _size = 20.0;
  bool? _value;
  bool? _previousValue;
  Duration? _previousDuration;

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final origin = size / 2.0 - Size.fromRadius(_size) / 2.0 as Offset;
    final status = position.status;
    final tNormalized =
        status == AnimationStatus.forward || status == AnimationStatus.completed
            ? position.value
            : 1.0 - position.value;

    final t = value == false ? 1.0 - tNormalized : tNormalized;

    _drawCircle(canvas, origin, t);
    _drawMyCheck(canvas, origin, t, _createCheckPaint()..color = _colorAt(t));
  }

  Color _colorAt(double t) {
    return Color.lerp(inactiveColor, activeColor, t)!;
  }

  Paint _createCheckPaint() {
    return Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth;
  }

  void _drawCircle(
    Canvas canvas,
    Offset outer,
    // Paint paint,
    double t,
  ) {
    var paintStroke = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    var paintFill = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var offset = const Offset(28, 28);

    if (t > 0.5) {
      canvas.drawCircle(offset, 0.0, paintFill);
    }
    if (t > 0.45) {
      canvas.drawCircle(offset, 1.0, paintFill);
    }
    if (t > 0.4) {
      canvas.drawCircle(offset, 2.0, paintFill);
    }
    if (t > 0.35) {
      canvas.drawCircle(offset, 3.0, paintFill);
    }
    if (t > 0.3) {
      canvas.drawCircle(offset, 4.0, paintFill);
    }
    if (t > 0.25) {
      canvas.drawCircle(offset, 5.0, paintFill);
    }
    if (t > 0.2) {
      canvas.drawCircle(offset, 6.0, paintFill);
    }
    if (t > 0.15) {
      canvas.drawCircle(offset, 7.0, paintFill);
    }
    if (t > 0.1) {
      canvas.drawCircle(offset, 8.0, paintFill);
    }
    if (t > 0) {
      canvas.drawCircle(offset, 9.0, paintFill);
    }
    canvas.drawCircle(offset, 10.0, paintStroke);
  }

  void _drawMyCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    final pathLeft = Path();
    final pathRight = Path();
    const start = Offset(30, 30);

    if (t >= 0.5 && t < 0.6) {
      pathLeft
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 3, start.dy + 2);

      pathRight
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 3, start.dy + 2);
    }
    if (t >= 0.6 && t < 0.7) {
      pathLeft
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 4, start.dy + 1);

      pathRight
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 1.5, start.dy);
    }
    if (t >= 0.7 && t < 0.8) {
      pathLeft
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 5, start.dy);

      pathRight
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx, start.dy - 2);
    }
    if (t >= 0.8 && t < 0.9) {
      pathLeft
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 6, start.dy - 1);

      pathRight
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx + 1.5, start.dy - 4);
    }
    if (t >= 0.9) {
      pathLeft
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx - 7, start.dy - 2);

      pathRight
        ..moveTo(start.dx - 3, start.dy + 2)
        ..lineTo(start.dx + 3, start.dy - 6);
    }

    canvas.drawPath(
        pathLeft,
        paint
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round);

    canvas.drawPath(
        pathRight,
        paint
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round);
  }
}
