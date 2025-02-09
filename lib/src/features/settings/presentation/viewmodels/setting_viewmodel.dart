import 'dart:async';

import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class SettingViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> signOut({required void Function() onSuccess}) async {
    try {
      setLoading(true);
      CustomNavigation().pop();
      await Future.delayed(Duration(seconds: 2));
      await _authRepository.signOut();

      onSuccess();
    } catch (e) {
      // Show an error message if login fails
      SnackBarUtils.show(e.toString(), SnackBarType.error);
    } finally {
      setLoading(false);
    }
  }
}
