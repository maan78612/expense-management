import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';

class CustomLoader extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loader;

  const CustomLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.loader,
  });

  @override
  State<StatefulWidget> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Alternate direction
    _animation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ModalProgressHUD(
        inAsyncCall: widget.isLoading,
        opacity: 0.55,
        progressIndicator: ScaleTransition(
          scale: _animation,
          child: Container(
           
            decoration: BoxDecoration( color: AppColors.darkPrimaryColor,borderRadius: BorderRadius.all(Radius.circular(7))),
            padding: EdgeInsets.all(14),
            child: widget.loader ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.sp,
                      width: 24.sp,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.blackColor)),
                    ),
                    8.horizontalSpace,
                    Text(
                      'Loading',
                      style: PoppinsStyles.regular(
                              color: AppColors.blackColor)
                          .copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
