import 'package:flutter/material.dart';

/// Dismisses the soft keyboard if a text field is focused.
void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

/// Wraps [child] so taps outside editable fields can dismiss the keyboard.
///
/// Prefer [TextField.onTapOutside] on individual fields; this is a belt-and-
/// suspenders fallback for chrome taps that do not hit a scrollable.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissKeyboard,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
