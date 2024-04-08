import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/config/string_constants.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/pages/navigation_controller.dart';
import '../../core/ui_utils/app_logo_widget.dart';
import '../../core/ui_utils/loaders/linear_loading_indicator_widget.dart';
import '../../core/ui_utils/spacing_utils.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _performInitialLoading();
      },
    );
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddVerticalSpacing(value: 130.h),
            AppLogoWidget(
              size: 200.sp,
            ),
            AddVerticalSpacing(value: 100.h),
            const LinearLoadingIndicatorWidget(),
            AddVerticalSpacing(value: 10.h),
            Text(
              StringConstants.appName,
              style: TextStyle(
                fontSize: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performInitialLoading() async {
    await AccountManager.init();
    if (!AccountManager.instance.isLoggedIn) {
      NavigationController.toLoginPage();
      return;
    }
    NavigationController.navigateLoggedInUser();
  }
}
