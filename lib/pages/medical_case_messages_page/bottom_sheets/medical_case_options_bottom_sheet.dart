import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/config/theme/app_colors.dart';
import 'package:medical_center_doctor/core/services/http_service.dart';
import 'package:medical_center_doctor/core/ui_utils/loaders/linear_loading_indicator_widget.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/pages/medical_case_details_page/medical_case_details_page.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import '../../../core/ui_utils/spacing_utils.dart';

class MedicalCaseOptionsBottomSheet extends StatefulWidget {
  const MedicalCaseOptionsBottomSheet({
    super.key,
    required this.caseDetails,
  });

  final MedicalCaseDetails caseDetails;

  @override
  State<MedicalCaseOptionsBottomSheet> createState() =>
      _MedicalCaseOptionsBottomSheetState();
}

class _MedicalCaseOptionsBottomSheetState
    extends State<MedicalCaseOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isEndingCase,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4.h,
              width: MediaQuery.sizeOf(context).width * .25,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            AddVerticalSpacing(value: 25.h),
            Text(
              'المريض',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
            ),
            AddVerticalSpacing(value: 7.h),
            Text(
              '${widget.caseDetails.patient.firstName} ${widget.caseDetails.patient.lastName}',
              style: TextStyle(
                fontSize: 23.sp,
              ),
            ),
            AddVerticalSpacing(value: 13.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.5.h,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      isEndingCase ? 'يتم الان الانهاء' : 'الخيارات',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.5.h,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: 400.milliseconds,
              curve: Curves.fastLinearToSlowEaseIn,
              child: Builder(
                builder: (context) {
                  if (!isEndingCase) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.monitor_heart),
                          onTap: () => Get.to(
                            MedicalCaseDetailsPage(
                              medicalCaseDetails: widget.caseDetails,
                            ),
                          ),
                          title: const Text('عرض معلومات الحالة'),
                          subtitle: const Text(
                              'عرض التخيص المقترح والاعراض المدخلة من قبل المريض'),
                        ),
                        ListTile(
                          onTap: endMedicalCase,
                          leading: const Icon(Icons.cancel),
                          title: const Text('انهاء الحالة المرضية'),
                          subtitle: const Text(
                            'انهاء الحالة الطبية ونقلها الى الحالات المنتهية, سيؤدي ذلك الى منع ارسال رسائل ضمن الحالة',
                          ),
                        ),
                        AddVerticalSpacing(value: 20.h),
                      ],
                    );
                  }
                  return SizedBox(
                    height: 80.h,
                    child: const Center(
                      child: LinearLoadingIndicatorWidget(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isEndingCase = false;

  Future<void> endMedicalCase() async {
    try {
      isEndingCase = true;
      setState(() {});
      int caseId = widget.caseDetails.medicalCase.id;
      var result = await HttpService.rawFullResponsePost(
        endPoint: 'medicalCases/$caseId/endCase/',
        body: {
          'doctorId': AccountManager.instance.user!.id,
        },
      );
      if (result.statusCode == 200) {
        Get.back(result: true);
      }
    } finally {
      isEndingCase = false;
      setState(() {});
    }
  }
}
