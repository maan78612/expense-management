import 'dart:developer';

import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:expense_managment/src/features/dashboard/domain/models/subscription.dart';
import 'package:expense_managment/src/features/dashboard/domain/repositories/dashboard_repository.dart';

import 'package:flutter/material.dart';

class DashBoardViewModel with ChangeNotifier {
  final DashBoardRepository _dashBoardRepository = DashBoardRepositoryImpl();
  List<GetSubscriptionModel> subscriptionList = [];

  int selectedIndex = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void selectIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  Future<void> initMethod(BuildContext context, int index) async {
    selectIndex(index);
  }
}
