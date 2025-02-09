import 'package:expense_managment/firebase_options.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/core/manager/theme_manager.dart';
import 'package:expense_managment/src/core/services/notification/firebase_notification_manager.dart';
import 'package:expense_managment/src/features/splash/presentation/views/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await _initMethod();

  bool isDarkMode = await ThemeManager().getThemeState();

  runApp(
    ProviderScope(
      overrides: [
        colorModeProvider.overrideWith(
          (ref) => ColorModeNotifier()
            ..setColorMode(isDarkMode ? ColorMode.dark : ColorMode.light),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _initMethod() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FBNotificationManager().init();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  /// below is a top level function we have to call it If we want background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: false,
      builder: (_, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: CustomNavigation().navigatorKey,
            title: 'Firebase Structure',
            home: SplashView(),
          ),
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "\n---------------- Handling a background message: ${message.messageId} ---------------------");
}
