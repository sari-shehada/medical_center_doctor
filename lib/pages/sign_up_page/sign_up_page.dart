import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';
import 'package:medical_center_doctor/models/doctor_info.dart';
import 'package:medical_center_doctor/pages/sign_up_page/doctor_sign_up_form.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/http_service.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/ui_utils/buttons/custom_filled_button.dart';
import '../../core/ui_utils/spacing_utils.dart';
import '../../core/ui_utils/text_fields/custom_text_field.dart';
import '../../core/widgets/date_time_input_widget.dart';
import '../../core/widgets/gender_toggle_widget.dart';
import '../../managers/account_manager.dart';

import '../navigation_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DoctorSignUpForm form = DoctorSignUpForm();
  Rx<CustomButtonStatus> signUpButtonStatus = CustomButtonStatus.enabled.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إنشاء حساب جديد',
        ),
        foregroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: form.firstNameController,
              inputAction: TextInputAction.next,
              label: 'الاسم الأول',
            ),
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: form.lastNameController,
              inputAction: TextInputAction.next,
              label: 'الاسم الأخير',
            ),
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: form.usernameController,
              inputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              label: 'اسم المستخدم',
            ),
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: form.passwordController,
              inputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              obscureText: true,
              label: 'كلمة المرور',
            ),
            AddVerticalSpacing(value: 15.h),
            CustomTextField(
              controller: form.passwordConfirmationController,
              textDirection: TextDirection.ltr,
              obscureText: true,
              label: 'تأكيد كلمة المرور',
            ),
            AddVerticalSpacing(value: 15.h),
            DateOfBirthInputWidget(
              dateOfBirth: form.dateOfBirth,
            ),
            AddVerticalSpacing(value: 15.h),
            DateTimeInputWidget(
              label: 'تاريخ بدء مزاولة المهنة',
              pickDateCallback: () => form.chooseCareerStartDate(context),
              value: form.careerStartDate,
              chooseLabelPrompt: 'اختيار تاريخ',
              valueDisplayText: (value) =>
                  '${value.getDateOnly()} (إعادة الاختيار)',
            ),
            AddVerticalSpacing(value: 15.h),
            GenderToggleWidget(
              isMale: form.isMale,
            ),
            AddVerticalSpacing(value: 15.h),
            Text(
              'صورة الشهادة',
              style: TextStyle(fontSize: 20.sp),
            ),
            AddVerticalSpacing(value: 25.h),
            Align(
              child: Container(
                height: 250.sp,
                width: 250.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    width: 1.5.sp,
                    color: primaryColor,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    if (await form.pickMedicineImage()) {
                      setState(() {});
                    }
                  },
                  child: form.certificateImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo,
                                size: 55.sp,
                                color: Colors.grey.shade800,
                              ),
                              AddVerticalSpacing(value: 15.h),
                              Text(
                                'قم باختيار صورة',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          form.certificateImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            AddVerticalSpacing(value: 20.h),
            CustomFilledButton(
              onTap: () => signUp(),
              buttonStatus: signUpButtonStatus,
              child: 'إنشاء حساب',
            ),
            AddVerticalSpacing(value: 13.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لديك حساب بالفعل؟'),
                TextButton(
                  onPressed: () => NavigationController.toLoginPage(),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    String? validationMessage = form.validateForm();
    if (validationMessage != null) {
      SnackBarService.showErrorSnackbar(validationMessage);
      return;
    }
    try {
      signUpButtonStatus.value = CustomButtonStatus.processing;
      var requestResult = await HttpService.dioMultiPartPost(
        endPoint: 'doctors/new/',
        formData: await form.toDioFormData(),
      );
      var data = requestResult.data;
      if (requestResult.statusCode == 201) {
        DoctorInfo userInfo = DoctorInfo.fromMap(data);
        await AccountManager.instance.login(userInfo);
        NavigationController.navigateLoggedInUser();
        return;
      }
      if (requestResult.statusCode == 400) {
        if (data.containsKey('username')) {
          SnackBarService.showErrorSnackbar(
            'اسم المستخدم المدخل تم اخذه من قبل طبيب اخر, يرجى اختيار اسم بديل',
          );
          return;
        }
      }
    } finally {
      signUpButtonStatus.value = CustomButtonStatus.enabled;
    }
  }
}
