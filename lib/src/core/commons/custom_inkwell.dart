import 'package:flutter/material.dart';

class CommonInkWell extends InkWell {
  const CommonInkWell(
      {super.key,
        super.child,
        super.onTap,
        bool enableFeedback = true,
        super.borderRadius})
      : super(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    enableFeedback: enableFeedback,
  );
}