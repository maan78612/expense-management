import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/commons/custom_input_field.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/commons/success_dialog.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/constants/text_field_validator.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/core/utilities/dialog_box.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/presentation/viewmodels/signup_viewmodel.dart';
import 'package:expense_managment/src/features/auth/presentation/views/login_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends ConsumerWidget {
  final signupViewModelProvider =
      ChangeNotifierProvider<SignUpViewModel>((ref) {
    return SignUpViewModel();
  });

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupViewModel = ref.watch(signupViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: signupViewModel.isLoading,
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
                  closeIcon(colorMode),
                  Text(
                    "Create Account!",
                    style: PoppinsStyles.bold(
                            color:
                                AppColorHelper.getPrimaryTextColor(colorMode))
                        .copyWith(fontSize: 22.sp),
                  ),
                  10.verticalSpace,
                  Text(
                    "Please enter your account here",
                    style: PoppinsStyles.regular(
                            color:
                                AppColorHelper.getPrimaryTextColor(colorMode))
                        .copyWith(fontSize: 14.sp, color: AppColors.greyColor),
                  ),
                  35.verticalSpace,
                  CustomInputField(
                    prefixWidget: Image.asset(AppImages.person,
                        color: AppColorHelper.getIconColor(colorMode),
                        width: 16.sp,
                        height: 16.sp,
                        fit: BoxFit.contain),
                    hint: "Name",
                    textInputAction: TextInputAction.next,
                    controller: signupViewModel.nameCon,
                    onChange: (value) {
                      signupViewModel.onChange(
                          con: signupViewModel.nameCon,
                          value: value,
                          validator: TextFieldValidator.validatePersonName);
                    },
                    colorMode: colorMode,
                  ),
                  CustomInputField(
                    colorMode: colorMode,
                    prefixWidget: Image.asset(
                      AppImages.email,
                      color: AppColorHelper.getIconColor(colorMode),
                    ),
                    hint: "Email",
                    controller: signupViewModel.emailCon,
                    textInputAction: TextInputAction.next,
                    onChange: (value) {
                      signupViewModel.onChange(
                          con: signupViewModel.emailCon,
                          value: value,
                          validator: TextFieldValidator.validateEmail);
                    },
                  ),
                  CustomInputField(
                    colorMode: colorMode,
                    prefixWidget: Image.asset(AppImages.password,
                        color: AppColorHelper.getIconColor(colorMode)),
                    hint: "Password",
                    controller: signupViewModel.passwordCon,
                    textInputAction: TextInputAction.next,
                    onChange: (value) {
                      signupViewModel.onChange(
                          con: signupViewModel.passwordCon,
                          value: value,
                          validator: TextFieldValidator.validatePassword);
                    },
                    obscure: true,
                  ),
                  CustomInputField(
                    colorMode: colorMode,
                    prefixWidget: Image.asset(AppImages.password,
                        color: AppColorHelper.getIconColor(colorMode)),
                    hint: "Confirm Password",
                    textInputAction: TextInputAction.done,
                    controller: signupViewModel.confirmPasswordCon,
                    onChange: (value) {
                      signupViewModel.onChange(
                          con: signupViewModel.confirmPasswordCon,
                          value: value,
                          validator: TextFieldValidator.validatePassword);
                    },
                    obscure: true,
                  ),
                  21.verticalSpace,
                  CustomButton(
                    title: 'Sign Up',
                    isEnable: signupViewModel.isBtnEnable,
                    bgColor: AppColorHelper.getPrimaryColor(colorMode),
                    onPressed: () {
                      signupViewModel.signUpButton(onSuccess: () {
                        CustomNavigation().pop();
                        DialogBoxUtils.show(SuccessDialog(
                            text: 'Account has been created successfully',
                            heading: 'Account created!',
                            colorMode: colorMode,
                            img: AppImages.successIcon));
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.sp),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: PoppinsStyles.regular(
                                    color: AppColorHelper.getPrimaryTextColor(
                                        colorMode))
                                .copyWith(fontSize: 16.sp),
                          ),
                          WidgetSpan(
                            child: CommonInkWell(
                                onTap: () {
                                  CustomNavigation()
                                      .pushReplacement(LoginView());
                                },
                                child: Text(
                                  " Sign in",
                                  style: PoppinsStyles.bold(
                                          color: AppColorHelper.getPrimaryColor(
                                              colorMode))
                                      .copyWith(
                                    fontSize: 16.sp,
                                  ),
                                )),
                          ),
                        ],
                      ),
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

  Widget closeIcon(ColorMode colorMode) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h, bottom: 50.h),
      child: CommonInkWell(
        onTap: () {
          CustomNavigation().pop();
        },
        child: Align(
            alignment: Alignment.topLeft,
            child: Icon(Icons.close,
                color: AppColorHelper.getIconColor(colorMode))),
      ),
    );
  }
}
