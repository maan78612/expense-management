import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/features/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:expense_managment/main.dart' as app;
import 'package:expense_managment/src/features/dashboard/presentation/views/dashboard_screen.dart';

void main() {
  // Ensure the integration test binding is initialized.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Tests', () {
    testWidgets('End-to-End: Splash -> Login -> Dashboard', (tester) async {
      // Wrap the splash phase in a try-catch to capture errors.
      try {
        // Launch the app.
        app.main();
        // Wait for initial render and for the splash animation plus delay to complete.
        await tester.pumpAndSettle();// To start app
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();// To initiate screen before splash [on Android]
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle(); // Open splash screen
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      } catch (e, stackTrace) {
        fail("Exception during splash screen phase: $e\n$stackTrace");
      }

      expect(find.byType(LoginView), findsOneWidget); // Find Login view
      // Find the email and password fields by their keys.
      final emailField = find.byKey(const Key('email-field'));
      final passwordField = find.byKey(const Key('password-field'));


      // Tap and enter text into the email field.
      await tester.tap(emailField);
      await tester.pumpAndSettle();
      await tester.showKeyboard(emailField);
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Tap and enter text into the password field.
      await tester.tap(passwordField);
      await tester.pumpAndSettle();
      await tester.showKeyboard(passwordField);
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(passwordField, 'Password123!');
      await tester.pumpAndSettle();

      // Verify that the login button is enabled.
      final loginButton = find.byKey(const Key('login-button'));
      expect(
        tester.widget<CustomButton>(loginButton).isEnable,
        true,
        reason: 'Login button not enabled',
      );

      // Tap the login button.
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Finally, verify that the Dashboard screen is displayed.
      expect(find.byType(DashBoardScreen), findsOneWidget);
    });
  });
}
