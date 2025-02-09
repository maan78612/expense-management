import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_managment/src/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import the generated mocks.
import 'login_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginViewModel viewModel;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    // Use the generated mock.
    mockAuthRepository = MockAuthRepository();
    // Inject the mock repository into the view model.
    viewModel = LoginViewModel(authRepository: mockAuthRepository);
  });

  group('LoginViewModel Tests', () {
    test('Form validation enables button when valid', () {
      viewModel.emailCon.controller.text = 'valid@email.com';
      viewModel.passwordCon.controller.text = 'Password123!';
      viewModel.setEnableBtn();
      expect(viewModel.isBtnEnable, isTrue);
    });

    test('Login success navigates to dashboard', () async {
      // Arrange: Stub login to return a user.
      final user = UserModel.empty();
      when(mockAuthRepository.login(body: anyNamed('body')))
          .thenAnswer((_) async => user);

      // Act: Call login and capture the success callback.
      bool onSuccessCalled = false;
      await viewModel.login(onSuccess: (loggedUser) {
        onSuccessCalled = true;
        expect(loggedUser, user);
      });

      // Assert
      expect(onSuccessCalled, isTrue);
    });

    test('Auto login skips login screen when authenticated', () async {
      final user = UserModel.empty();
      when(mockAuthRepository.autoLogin()).thenAnswer((_) async => user);

      bool callbackCalled = false;
      // Act: Call autoLogin and capture the callback.
      await viewModel.autoLogin(onSuccess: (loggedUser) {
        callbackCalled = true;
        expect(loggedUser, user);
      });

      // Assert
      expect(callbackCalled, isTrue);
    });
  });
}

///*-------------> Steps for unit testing implementation<------------------------*///

///---->1: Add dev dependencies  [  mockito: ^5.4.2 &   build_runner: ^2.4.6]
///---->2:add the @GenerateMocks annotation above your main() function. This tells build runner to generate the mock classes needed for your tests
///---->3: Run command [flutter pub run build_runner build]
///     "This command scans your project for code generation annotations
///     (like @GenerateMocks) and generates the corresponding files
///     (e.g., login_viewmodel_test.mocks.dart)"
///---->4: Run test by command "flutter test test/unit/auth/login_viewmodel_test.dart"
