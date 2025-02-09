import 'package:expense_managment/src/core/commons/common_app_bar.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/enums/notification_type.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/features/notifications/presentation/viewmodels/notifications_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends ConsumerState<NotificationsView> {
  final _notificationsViewModelProvider =
      ChangeNotifierProvider<NotificationsViewModel>((ref) {
    return NotificationsViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(_notificationsViewModelProvider)
          .init(ref.read(userModelProvider));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsViewModel = ref.watch(_notificationsViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: notificationsViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        appBar: CommonAppBar(
          title: 'Notifications',
          onTap: () {
            CustomNavigation().pop();
          },
          colorMode: colorMode,
        ),
        body: SafeArea(
          child: notificationsViewModel.notifications.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMargin),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: notificationsViewModel
                          .groupedNotifications.entries
                          .map((entry) {
                        return entry.value.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0.sp),
                                    child: Text(
                                      entry.key,
                                      style: PoppinsStyles.semiBold(
                                              color: AppColorHelper
                                                  .getPrimaryTextColor(
                                                      colorMode))
                                          .copyWith(fontSize: 18.sp),
                                    ),
                                  ),
                                  ...entry.value.map((notification) {
                                    return Slidable(
                                      key: UniqueKey(),
                                      endActionPane: ActionPane(
                                        dismissible:
                                            DismissiblePane(onDismissed: () {
                                          notificationsViewModel
                                              .deleteNotification(
                                                  entry.key, notification);
                                        }),
                                        extentRatio: 0.3,
                                        motion: const DrawerMotion(),
                                        children: [
                                          SlidableAction(
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                            onPressed: (BuildContext context) {
                                              notificationsViewModel
                                                  .deleteNotification(
                                                      entry.key, notification);
                                            },
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              notification.title,
                                              style: PoppinsStyles.medium(
                                                      color: notification
                                                                  .type ==
                                                              NotificationType
                                                                  .success
                                                          ? AppColors.greenColor
                                                          : notification.type ==
                                                                  NotificationType
                                                                      .failed
                                                              ? AppColors
                                                                  .redColor
                                                              : AppColors
                                                                  .orangeColor)
                                                  .copyWith(
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.sp),
                                              child: Text(
                                                notification.message,
                                                style: PoppinsStyles.regular(
                                                        color: AppColorHelper
                                                            .getSecondaryTextColor(
                                                                colorMode))
                                                    .copyWith(
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.sp),
                                              child: Text(
                                                formatDate(
                                                    notification.createdAt,
                                                    entry.key),
                                                style: PoppinsStyles.regular(
                                                        color: AppColorHelper
                                                            .getSecondaryTextColor(
                                                                colorMode))
                                                    .copyWith(
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                  if (entry.key != "Older")
                                    Divider(
                                        color: AppColorHelper.borderColor(
                                            colorMode)),
                                ],
                              )
                            : const SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                )
              : !notificationsViewModel.isLoading
                  ? Center(
                      child: Text(
                        "No Notifications",
                        style: PoppinsStyles.semiBold(
                            color:
                                AppColorHelper.getPrimaryTextColor(colorMode)),
                      ),
                    )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }

  String formatDate(DateTime date, String day) {
    final DateFormat formatter;
    String dateString = "";
    if (day == "Older") {
      formatter = DateFormat('MMM d, yyyy hh:mm:aa');
      dateString = formatter.format(date);
    } else {
      formatter = DateFormat('hh:mm:aa');
      dateString = "At ${formatter.format(date)}";
    }

    return dateString;
  }
}
