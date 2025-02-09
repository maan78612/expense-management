import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/features/splash/presentation/viewmodels/splash_viewmodel.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with TickerProviderStateMixin {
  /// Provider for the SplashViewModel using ChangeNotifierProvider
  final _splashViewModelProvider =
      ChangeNotifierProvider<SplashViewModel>((ref) {
    return SplashViewModel();
  });

  @override
  void initState() {
    super.initState();

    /// call init method with this State as the TickerProvider
    ref.read(_splashViewModelProvider).initFunc(this);
  }

  @override
  Widget build(BuildContext context) {
    /// Watch the SplashViewModel for changes
    final splashViewModel = ref.watch(_splashViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return Scaffold(
      backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
      body: Center(
        child: ScaleTransition(
          scale: splashViewModel.animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  colorMode == ColorMode.light
                      ? AppImages.logoBlack
                      : AppImages.logoWhite,
                  width: 0.9.sw,
                  fit: BoxFit.cover),
              20.verticalSpace,
              Text("Technical Assessment",
                  style: PoppinsStyles.regular(
                      color: AppColorHelper.getPrimaryTextColor(colorMode))),
              14.verticalSpace,
              Text("Sr. Flutter Developer",
                  style: PoppinsStyles.extraBold(
                          color: AppColorHelper.getPrimaryTextColor(colorMode))
                      .copyWith(fontSize: 24.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
