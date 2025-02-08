import 'package:flutter/material.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/features/auth/presentation/views/login_view.dart';
import 'package:expense_managment/src/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:expense_managment/src/features/splash/domain/repositories/splash_repository.dart';

class SplashViewModel extends ChangeNotifier {
  /// Repository for splash-related data operations
  final SplashRepository _splashRepository = SplashRepositoryImpl();

  /// Animation controller for handling splash screen animations
  late AnimationController _controller;

  /// Animation object to handle the transition
  late Animation<double> _animation;

  Animation<double> get animation => _animation;

  /// Initialization function to setup the animation controller
  void initFunc(TickerProvider tickerProvider) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: tickerProvider,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _controller.addListener(() async {
      if (_controller.status == AnimationStatus.completed) {
        /// Wait for 1 second before navigating
        await Future.delayed(const Duration(milliseconds: 1000));
        CustomNavigation().pushAndRemoveUntil(LoginView(), animate: false);
      }
    });
  }

  @override
  void dispose() {
    /// Dispose of the animation controller to free up resources
    _controller.dispose();
    super.dispose();
  }
}
