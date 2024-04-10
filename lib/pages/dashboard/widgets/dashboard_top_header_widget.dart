import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/ui_utils/app_logo_widget.dart';
import '../../../core/ui_utils/spacing_utils.dart';
import '../../../managers/account_manager.dart';

class DashboardTopHeaderWidget extends StatelessWidget {
  const DashboardTopHeaderWidget({
    super.key,
    this.shouldHideUserChip = false,
  });

  final bool shouldHideUserChip;

  @override
  Widget build(BuildContext context) {
    assert(AccountManager.instance.user != null);
    var user = AccountManager.instance.user!;
    return Row(
      children: [
        AppLogoWidget(
          size: 35.sp,
        ),
        AddHorizontalSpacing(value: 8.w),
        Text(
          'المركز الطبي',
          style: TextStyle(
            fontSize: 18.sp,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        AnimatedOpacity(
          opacity: shouldHideUserChip ? 0 : 1,
          duration: 400.milliseconds,
          curve: Curves.fastLinearToSlowEaseIn,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                AddHorizontalSpacing(value: 10.w),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: CircleAvatar(
                    radius: 12.sp,
                    backgroundColor: Colors.black.withOpacity(0.2),
                    child: Icon(
                      user.isMale ? Icons.male : Icons.female,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
