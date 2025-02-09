import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/auth/presentation/views/signup_view.dart';
import 'package:expense_managment/src/features/dashboard/presentation/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/core/commons/custom_input_field.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/constants/text_field_validator.dart';
import 'package:expense_managment/src/features/auth/presentation/viewmodels/login_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
    return LoginViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(loginViewModelProvider).autoLogin(onSuccess: (UserModel user) {
        ref.read(userModelProvider.notifier).setUser(user);
        CustomNavigation().pushAndRemoveUntil(const DashBoardScreen());
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.watch(loginViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: loginViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hMargin),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  50.verticalSpace,
                  Image.asset(
                      colorMode == ColorMode.light
                          ? AppImages.logoBlack
                          : AppImages.logoWhite,
                      width: 0.6.sw,
                      fit: BoxFit.cover),
                  10.verticalSpace,
                  Text(
                    "Please enter your account here",
                    style: PoppinsStyles.regular(
                            color:
                                AppColorHelper.getPrimaryTextColor(colorMode))
                        .copyWith(fontSize: 14.sp, color: AppColors.greyColor),
                  ),
                  60.verticalSpace,
                  CustomInputField(
                    prefixWidget: Image.asset(AppImages.email,
                        color: AppColorHelper.getIconColor(colorMode)),
                    hint: "Email",
                    textInputAction: TextInputAction.next,
                    controller: loginViewModel.emailCon,
                    onChange: (value) {
                      loginViewModel.onChange(
                          con: loginViewModel.emailCon,
                          value: value,
                          validator: TextFieldValidator.validateEmail);
                    },
                    colorMode: colorMode,
                  ),
                  10.verticalSpace,
                  CustomInputField(
                    prefixWidget: Image.asset(AppImages.password,
                        color: AppColorHelper.getIconColor(colorMode)),
                    hint: "Password",
                    textInputAction: TextInputAction.done,
                    controller: loginViewModel.passwordCon,
                    onChange: (value) {
                      loginViewModel.onChange(
                          con: loginViewModel.passwordCon,
                          value: value,
                          validator: TextFieldValidator.validatePassword);
                    },
                    obscure: true,
                    colorMode: colorMode,
                  ),
                  10.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password?",
                        style: PoppinsStyles.medium(
                                color:
                                    AppColorHelper.getPrimaryColor(colorMode))
                            .copyWith(
                          fontSize: 15.sp,
                        )),
                  ),
                  120.verticalSpace,
                  CustomButton(
                    title: 'Login',
                    isEnable: loginViewModel.isBtnEnable,
                    bgColor: AppColorHelper.getPrimaryColor(colorMode),
                    onPressed: () {
                      loginViewModel.login(onSuccess: (UserModel user) {
                        ref.read(userModelProvider.notifier).setUser(user);
                        CustomNavigation()
                            .pushAndRemoveUntil(const DashBoardScreen());
                      });
                    },
                  ),
                  20.verticalSpace,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don’t have an account? ",
                          style: PoppinsStyles.regular(
                                  color: AppColorHelper.getPrimaryTextColor(
                                      colorMode))
                              .copyWith(fontSize: 16.sp),
                        ),
                        WidgetSpan(
                          child: CommonInkWell(
                              onTap: () {
                                loginViewModel.clearForm();
                                CustomNavigation().push(SignUpScreen());
                              },
                              child: Text(
                                " Sign Up",
                                style: PoppinsStyles.bold(
                                        color: AppColorHelper.getPrimaryColor(
                                            colorMode))
                                    .copyWith(fontSize: 16.sp),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
