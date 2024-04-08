import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/config/theme/app_colors.dart';
import 'package:medical_center_doctor/core/services/shared_prefs_service.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';

class DoctorRejectedDialog extends StatelessWidget {
  const DoctorRejectedDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * .9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cancel,
                size: 80.sp,
                color: error,
              ),
              AddVerticalSpacing(value: 10.h),
              Text(
                'للأسف.. لم تتم الموافقة على طلب انتسابك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
              AddVerticalSpacing(value: 15.h),
              Text(
                'قد يكون ذلك بسبب خلل في المعلومات التي قمت بتزويدنا بها,لكن لا يزال بالامكان المحاولة مجدداً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              AddVerticalSpacing(value: 40.h),
              FilledButton(
                onPressed: () async {
                  await SharedPreferencesService.instance.plugin.remove(
                    'userId',
                  );
                  Get.back();
                },
                child: const Text(
                  'حسناً',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
