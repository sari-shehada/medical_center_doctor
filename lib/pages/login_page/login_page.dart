import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/pages/login_page/dialogs/doctor_rejected_dialog.dart';
import '../../managers/account_manager.dart';
import '../../models/doctor_info.dart';
import '../navigation_controller.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/ui_utils/app_logo_widget.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../../core/ui_utils/text_fields/custom_text_field.dart';
import 'models/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.isUserRejected = false,
  });

  final bool isUserRejected;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Rx<CustomButtonStatus> loginButtonStatus = CustomButtonStatus.enabled.obs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (widget.isUserRejected) {
          Get.dialog(
            const DoctorRejectedDialog(),
          );
        }
      },
    );
    return Scaffold(
      body: SizedBox.expand(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            AddVerticalSpacing(value: MediaQuery.sizeOf(context).height * .35),
            AppLogoWidget(
              size: 120.sp,
            ),
            AddVerticalSpacing(value: 20.h),
            Align(
              child: Text(
                'مرحبا بك في المركز الطبي',
                style: TextStyle(
                  fontSize: 26.sp,
                  color: primaryColor,
                ),
              ),
            ),
            AddVerticalSpacing(value: 8.h),
            Align(
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 19.sp,
                ),
              ),
            ),
            AddVerticalSpacing(value: 24.h),
            CustomTextField(
              controller: usernameController,
              textDirection: TextDirection.ltr,
              inputAction: TextInputAction.next,
              label: 'اسم المستخدم',
            ),
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: passwordController,
              textDirection: TextDirection.ltr,
              label: 'كلمة المرور',
            ),
            AddVerticalSpacing(value: 20.h),
            CustomFilledButton(
              onTap: () => login(),
              buttonStatus: loginButtonStatus,
              child: 'تسجيل الدخول',
            ),
            AddVerticalSpacing(value: 13.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لا تمتلك حساباً؟'),
                TextButton(
                  onPressed: () => NavigationController.toSignUpPage(),
                  child: const Text('إنشاء حساب جديد'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    LoginForm loginForm = LoginForm(
      username: usernameController.text,
      password: passwordController.text,
    );
    String? validationMessage = loginForm.validateForm();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    try {
      loginButtonStatus.value = CustomButtonStatus.processing;
      String requestResult = await HttpService.rawPost(
        endPoint: 'doctors/login/',
        body: loginForm.toMap(),
      );
      var decodedResult = jsonDecode(requestResult);
      if (decodedResult == false) {
        SnackBarService.showErrorSnackbar(
          'معلومات تسجيل دخول غير صحيحة',
        );
        return;
      }
      DoctorInfo userInfo = DoctorInfo.fromMap(decodedResult);
      await AccountManager.instance.login(userInfo);
      NavigationController.navigateLoggedInUser();
    } finally {
      loginButtonStatus.value = CustomButtonStatus.enabled;
    }
  }
}
