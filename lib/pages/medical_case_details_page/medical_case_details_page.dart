import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/config/theme/app_colors.dart';
import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';
import 'package:medical_center_doctor/core/services/http_service.dart';
import 'package:medical_center_doctor/core/services/snackbar_service.dart';
import 'package:medical_center_doctor/core/ui_utils/buttons/custom_filled_button.dart';
import 'package:medical_center_doctor/core/ui_utils/custom_divider.dart';
import 'package:medical_center_doctor/core/ui_utils/gender_icon_widget.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/core/ui_utils/title_details_spaced_widget.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/models/symptom.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';

class MedicalCaseDetailsPage extends StatefulWidget {
  const MedicalCaseDetailsPage({
    super.key,
    required this.medicalCaseDetails,
  });

  final MedicalCaseDetails medicalCaseDetails;

  @override
  State<MedicalCaseDetailsPage> createState() => _MedicalCaseDetailsPageState();
}

class _MedicalCaseDetailsPageState extends State<MedicalCaseDetailsPage> {
  late MedicalCaseDetails medicalCaseDetails;

  bool modificationMade = false;

  @override
  void initState() {
    medicalCaseDetails = widget.medicalCaseDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => goBack(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.medicalCaseDetails.disease.name,
          ),
          centerTitle: true,
          backgroundColor: primaryContainer,
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                AddVerticalSpacing(value: 25.h),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  padding: EdgeInsets.all(
                    17.sp,
                  ),
                  child: GenderIconWidget(
                    isMale: widget.medicalCaseDetails.patient.isMale,
                    color: Colors.white,
                  ),
                ),
                AddVerticalSpacing(value: 10.h),
                Text(
                  widget.medicalCaseDetails.patient.fullName,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: primaryColor,
                  ),
                ),
                AddVerticalSpacing(value: 6.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'العمر:',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    AddHorizontalSpacing(value: 4.w),
                    Text(
                      '${widget.medicalCaseDetails.patient.dateOfBirth.getAge()} سنة',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                const CustomDivider(),
                TitleDetailsSpacedWidget(
                  icon: Icons.history,
                  title: 'تاريخ التشخيص',
                  details: widget
                      .medicalCaseDetails.patientDiagnosis.diagnosisDateTime
                      .getDateOnly(),
                ),
                AddVerticalSpacing(value: 10.h),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الأعراض المدخلة',
                  ),
                ),
                AddVerticalSpacing(value: 15.h),
                Expanded(
                  child: GridView.builder(
                    itemCount: widget.medicalCaseDetails.symptoms.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 6.h,
                      crossAxisSpacing: 6.w,
                      mainAxisExtent: 40.h,
                    ),
                    itemBuilder: (context, index) {
                      final Symptom symptom =
                          widget.medicalCaseDetails.symptoms[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: primaryContainer.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          symptom.name,
                        ),
                      );
                    },
                  ),
                ),
                const CustomDivider(),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'وضع الحالة الطبية',
                  ),
                ),
                AddVerticalSpacing(value: 15.h),
                MedicalCaseStatusTextWidget(
                  status: medicalCaseDetails.medicalCase.status,
                  takenBy: medicalCaseDetails.medicalCase.takenBy,
                ),
                AddVerticalSpacing(value: 15.h),
                Builder(
                  builder: (context) {
                    if (medicalCaseDetails.medicalCase.status == 'pending') {
                      return CustomFilledButton(
                        height: 50.h,
                        onTap: takeMedicalCase,
                        buttonStatus: buttonStatus,
                        child: 'الإشراف على هذه الحالة',
                      );
                    }
                    if (medicalCaseDetails.medicalCase.takenBy !=
                        AccountManager.instance.user!.id) {
                      return const SizedBox.shrink();
                    }
                    return CustomFilledButton(
                      height: 50.h,
                      onTap: () {},
                      child: 'عرض الرسائل',
                    );
                  },
                ),
                AddVerticalSpacing(value: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Rx<CustomButtonStatus> buttonStatus = CustomButtonStatus.enabled.obs;

  Future<void> takeMedicalCase() async {
    try {
      buttonStatus.value = CustomButtonStatus.processing;
      var result = await HttpService.rawFullResponsePost(
        endPoint: 'medicalCases/${medicalCaseDetails.medicalCase.id}/takeCase/',
        body: {
          'doctorId': AccountManager.instance.user!.id,
        },
      );
      if (result.statusCode == 200) {
        setMedicalCaseAsTakenBy(isTakenByMe: true);
        return;
      }
      if (result.statusCode == 400) {
        setMedicalCaseAsTakenBy(isTakenByMe: false);
      }
      //status is 404
      Get.back(result: true);
      SnackBarService.showErrorSnackbar('لقد تم مسح هذه الحالة من قبل المريض');
    } finally {
      buttonStatus.value = CustomButtonStatus.enabled;
    }
  }

  void setMedicalCaseAsTakenBy({
    required bool isTakenByMe,
  }) {
    medicalCaseDetails = medicalCaseDetails.copyWith(
      medicalCase: medicalCaseDetails.medicalCase.copyWith(
        status: 'taken',
        takenBy: isTakenByMe ? AccountManager.instance.user!.id : -1,
      ),
    );
    modificationMade = true;
    setState(() {});
  }

  bool goBack() {
    Get.back(result: modificationMade);
    return true;
  }
}

class MedicalCaseStatusTextWidget extends StatelessWidget {
  const MedicalCaseStatusTextWidget({
    super.key,
    required this.status,
    required this.takenBy,
  });

  final String status;
  final int? takenBy;
  @override
  Widget build(BuildContext context) {
    bool isTakenByMe = AccountManager.instance.user!.id == takenBy;
    return Text(
      status == 'pending'
          ? 'الحالة لاتزال بانتظار الاشراف من قبل أحد الأطباء'
          : status == 'ended'
              ? 'الحالة منتهية'
              : isTakenByMe
                  ? 'لقد تم تعيينك كمشرف على هذه الحالة'
                  : 'لقد قام طبيب اخر بالاشراف على هذه الحالة',
      style: TextStyle(
        fontSize: 15.sp,
      ),
    );
  }
}
