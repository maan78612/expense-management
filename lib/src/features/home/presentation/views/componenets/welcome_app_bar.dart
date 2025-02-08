part of 'package:expense_managment/src/features/home/presentation/views/home_view.dart';

class _WelcomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ColorMode colorMode;

  const _WelcomeAppBar({super.key, required this.colorMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);

    return ClipPath(
      clipper: WaveClipperOne(
        flip: true,
        reverse: false,
      ),
      child: Container(
        color: AppColorHelper.getPrimaryColor(colorMode),
        padding: EdgeInsets.only(bottom: 40.h, right: 10.w, left: 10.w),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Text(
                    "Welcome back!",
                    style: PoppinsStyles.medium(
                            color: AppColorHelper.getScaffoldColor(colorMode))
                        .copyWith(fontSize: 18.sp, height: 1),
                  ),
                  10.verticalSpace,
                  Text(
                    'user.name',
                    style: PoppinsStyles.bold(
                            color: AppColorHelper.getScaffoldColor(colorMode))
                        .copyWith(fontSize: 24.sp),
                  ),

                ],
              ),
              const Spacer(),
              Opacity(
                opacity: 0.8,
                child: Image.asset(
                    colorMode == ColorMode.light
                        ? AppImages.logoBlack
                        : AppImages.logoWhite,
                    width: 80.w,
                    fit: BoxFit.contain,
                    color: AppColorHelper.getScaffoldColor(colorMode)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(180.h); // Adjust the height as needed
}
