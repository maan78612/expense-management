import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/custom_text_controller.dart';
import 'package:expense_managment/src/core/commons/success_dialog.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/utilities/dialog_box.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class SignUpViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  CustomTextController emailCon = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());
  CustomTextController passwordCon = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());

  CustomTextController confirmPasswordCon = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());
  CustomTextController nameCon = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isBtnEnable = false;

  bool get isBtnEnable => _isBtnEnable;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void onChange(
      {required CustomTextController con,
      String? Function(String?)? validator,
      required String value}) {
    if (validator != null) {
      con.error = validator(value);
    }
    setEnableBtn();
  }

  void setEnableBtn() {
    if (emailCon.controller.text.isNotEmpty &&
        passwordCon.controller.text.isNotEmpty &&
        confirmPasswordCon.controller.text.isNotEmpty &&
        nameCon.controller.text.isNotEmpty) {
      if (emailCon.error == null &&
          passwordCon.error == null &&
          confirmPasswordCon.error == null &&
          nameCon.error == null) {
        _isBtnEnable = true;
      } else {
        _isBtnEnable = false;
      }
    } else {
      _isBtnEnable = false;
    }

    notifyListeners();
  }

  Future<void> signUpButton({required void Function() onSuccess}) async {
    if (passwordCon.controller.text != confirmPasswordCon.controller.text) {
      SnackBarUtils.show(
          "Password and confirm password does not match", SnackBarType.error);
    } else {
      try {
        setLoading(true);

        final body = {
          "email": emailCon.controller.text,
          "password": passwordCon.controller.text,
          "name": nameCon.controller.text,
        };

        await _authRepository.register(body: body);
        onSuccess();
      } catch (e) {
        SnackBarUtils.show(
            e.toString(), SnackBarType.error);
      } finally {
        setLoading(false);
      }
    }
  }
}
