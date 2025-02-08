import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:expense_managment/src/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'componenets/bottom_navigation_bar.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreen();
}

class _DashBoardScreen extends ConsumerState<DashBoardScreen> {
  final _dashBoardViewModelProvider =
      ChangeNotifierProvider<DashBoardViewModel>((ref) => DashBoardViewModel());

  @override
  Widget build(BuildContext context) {
    final dashBoardViewModel = ref.watch(_dashBoardViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: dashBoardViewModel.isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        body: _getPage(dashBoardViewModel),
        bottomNavigationBar: _BottomNavigationBar(
          selectedIndex: dashBoardViewModel.selectedIndex,
          onItemSelected: (index) {
            dashBoardViewModel.selectIndex(index);
          },
        ),
      ),
    );
  }

  Widget _getPage(DashBoardViewModel dashBoardViewModel) {
    switch (dashBoardViewModel.selectedIndex) {
      case 0:
        return const HomeView();
      case 1:
        return Container();
      case 2:
        return Container();

      default:
        return Container();
    }
  }
}
