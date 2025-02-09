import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:expense_managment/src/core/commons/custom_text_controller.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  // Inject AuthRepository via the constructor. If none is provided, use the real implementation.
  final AuthRepository authRepository;

  LoginViewModel({AuthRepository? authRepository})
      : authRepository = authRepository ?? AuthRepositoryImpl();

  // Controllers for email and password input fields
  CustomTextController emailCon = CustomTextController(
    controller: TextEditingController(),
    focusNode: FocusNode(),
  );

  CustomTextController passwordCon = CustomTextController(
    controller: TextEditingController(),
    focusNode: FocusNode(),
  );

  // Loading state to indicate when a process is running
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // State to manage whether the login button should be enabled
  bool _isBtnEnable = false;

  bool get isBtnEnable => _isBtnEnable;

  /// Sets the loading state and notifies listeners.
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  clearForm() {
    emailCon = CustomTextController(
        controller: TextEditingController(), focusNode: FocusNode());
    passwordCon = CustomTextController(
        controller: TextEditingController(), focusNode: FocusNode());
    notifyListeners();
  }

  /// Handles changes in the input fields, performs validation, and updates the button state.
  void onChange({
    required CustomTextController con,
    String? Function(String?)? validator,
    required String value,
  }) {
    if (validator != null) {
      con.error = validator(value);
    }
    debugPrint('Field validation error: ${con.error}');
    setEnableBtn();
  }

  /// Determines if the login button should be enabled based on input validation.
  void setEnableBtn() {
    _isBtnEnable = emailCon.controller.text.isNotEmpty &&
        passwordCon.controller.text.isNotEmpty &&
        emailCon.error == null &&
        passwordCon.error == null;
    debugPrint('Email: ${emailCon.controller.text}'); // Add this
    debugPrint('Password: ${passwordCon.controller.text}'); // Add this
    debugPrint('Button enabled: $_isBtnEnable');
    notifyListeners();
  }

  /// Attempts to log the user in by communicating with the authentication repository.
  Future<void> login({required void Function(UserModel) onSuccess}) async {
    try {
      setLoading(true);

      final body = {
        "email": emailCon.controller.text,
        "password": passwordCon.controller.text,
      };

      // Attempt to login using the provided credentials
      final loginUser = await authRepository.login(body: body);

      onSuccess(loginUser); // Pass loginUser as an argument to onSuccess
    } catch (e) {
      // Show an error message if login fails
      SnackBarUtils.show(e.toString(), SnackBarType.error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> autoLogin({required void Function(UserModel) onSuccess}) async {
    try {
      setLoading(true);

      final loginUser = await authRepository.autoLogin();

      if (loginUser != null) {
        onSuccess(loginUser); // Pass loginUser as an argument to onSuccess
      }
    } catch (e) {
      // Show an error message if auto-login fails
      SnackBarUtils.show(e.toString(), SnackBarType.error);
    } finally {
      setLoading(false);
    }
  }
}
