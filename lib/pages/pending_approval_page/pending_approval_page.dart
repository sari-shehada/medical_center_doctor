import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/config/theme/app_colors.dart';
import 'package:medical_center_doctor/core/ui_utils/app_logo_widget.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddVerticalSpacing(value: 50.h),
            AppLogoWidget(
              size: 130.sp,
            ),
            AddVerticalSpacing(value: 40.h),
            Text(
              'مرحباً ${AccountManager.instance.user!.firstName}',
              style: TextStyle(
                fontSize: 23.sp,
                color: primaryColor,
              ),
            ),
            AddVerticalSpacing(value: 35.h),
            Text(
              'الحساب لا يزال قيد المراجعة من مشرفي النظام',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                color: onBackground.withOpacity(0.7),
              ),
            ),
            AddVerticalSpacing(value: 15.h),
            Text(
              'العملية قد تستغرف عدة أيام',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: onBackground.withOpacity(0.7),
              ),
            ),
            AddVerticalSpacing(value: 3.h),
            Text(
              'يرجى الأنتظار فضلاً...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: onBackground.withOpacity(0.7),
              ),
            ),
            AddVerticalSpacing(value: 50.h),
            OutlinedButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text(
                'الخروج من التطبيق',
              ),
            ),
            AddVerticalSpacing(value: 10.h),
            OutlinedButton(
              onPressed: () => AccountManager.instance.logout(),
              child: const Text(
                'تسجيل الخروج',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
