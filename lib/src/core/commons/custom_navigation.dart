
import 'package:flutter/material.dart';
import 'package:expense_managment/src/core/constants/globals.dart';

class CustomNavigation {
  static final CustomNavigation _instance = CustomNavigation._internal();

  factory CustomNavigation() {
    return _instance;
  }

  CustomNavigation._internal();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  dynamic push(Widget page, {bool animate = true}) async {
    await Navigator.of(_navigatorKey.currentContext!).push(
      RoutingAnimation(
        child: page,
        animate: animate,
      ),
    );
  }

  void pushReplacement(Widget page, {bool animate = true}) {
    Navigator.of(_navigatorKey.currentContext!).pushReplacement(
      RoutingAnimation(
        child: page,
        animate: animate,
      ),
    );
  }

  void pushAndRemoveUntil(Widget page, {bool animate = true}) {
    Navigator.of(_navigatorKey.currentContext!).pushAndRemoveUntil(
      RoutingAnimation(child: page, animate: animate),
      (Route<dynamic> route) => false,
    );
  }

  void pop<T extends Object>([T? result]) {
    Navigator.of(_navigatorKey.currentContext!).pop<T>(result);
  }

  void popUntil(Widget page) {
    Navigator.of(_navigatorKey.currentContext!).popUntil(
        (route) => route.settings.name == page.runtimeType.toString());
  }
}

class RoutingAnimation extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
  final bool animate; // Add this parameter

  RoutingAnimation({
    this.direction = AxisDirection.left,
    required this.animate,
    required this.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: routingDuration),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animate) {
      // Check the animate parameter here
      return SlideTransition(
        position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero)
            .animate(animation),
        child: child,
      );
    } else {
      return child; // Return the child widget without animation
    }
  }

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
      default:
        return const Offset(-1, 0);
    }
  }
}
