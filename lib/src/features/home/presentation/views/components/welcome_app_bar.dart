part of 'package:expense_managment/src/features/home/presentation/views/home_view.dart';

class _WelcomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ColorMode colorMode;

  const _WelcomeAppBar({required this.colorMode});

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
        padding: EdgeInsets.only(bottom: 30.h, right: 10.w, left: 10.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome back!",
                      style: PoppinsStyles.medium(
                              color: AppColorHelper.getScaffoldColor(colorMode))
                          .copyWith(fontSize: 18.sp, height: 1),
                    ),
                    const Spacer(),
                    CommonInkWell(
                      onTap: () => CustomNavigation().push(NotificationsView()),
                      child: Icon(Icons.notifications,
                          color: AppColorHelper.getScaffoldColor(colorMode),
                          size: 24.sp),
                    ),
                  ]),
              10.verticalSpace,
              Center(
                child: Text(
                  user.name,
                  style: PoppinsStyles.semiBold(
                          color: AppColorHelper.getScaffoldColor(colorMode))
                      .copyWith(fontSize: 20.sp),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                      colorMode == ColorMode.light
                          ? AppImages.logoBlack
                          : AppImages.logoWhite,
                      width: 80.w,
                      fit: BoxFit.contain,
                      color: AppColorHelper.getScaffoldColor(colorMode)),
                ),
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
