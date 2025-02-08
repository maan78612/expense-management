import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/enums/tab_bar_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/features/home/presentation/viewmodels/home_viewmodel.dart';

part 'componenets/home_tab_bar.dart';

part 'componenets/welcome_app_bar.dart';

part 'componenets/chart.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  /// Initializing providers in Home because we need them after the home screen
  /// and they will dispose when the home screen is disposed.
  final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
    return HomeViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userModelProvider);
      ref.read(homeViewModelProvider).initMethod(user);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: homeViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        appBar: _WelcomeAppBar(colorMode: colorMode),
        body: Column(
          children: [
            _HomeTabBar(
              homeViewModelProvider: homeViewModelProvider,
              colorMode: colorMode,
            ),
            30.verticalSpace,
            _Chart(homeViewModelProvider),
          ],
        ),
      ),
    );
  }
}
