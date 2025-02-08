import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextController {
  TextEditingController controller;
  FocusNode focusNode;
  String? error;

  CustomTextController(
      {required this.controller, this.error, required this.focusNode});
}
