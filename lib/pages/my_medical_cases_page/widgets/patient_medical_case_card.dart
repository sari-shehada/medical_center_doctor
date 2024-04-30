import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/core/ui_utils/buttons/custom_icon_button.dart';
import 'package:medical_center_doctor/pages/medical_case_messages_page/medical_case_messages_page.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/extensions/date_time_extensions.dart';

class PatientMedicalCaseCard extends StatelessWidget {
  const PatientMedicalCaseCard({
    super.key,
    required this.medicalCaseDetails,
  });

  final MedicalCaseDetails medicalCaseDetails;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      title: Row(
        children: [
          Text(
            medicalCaseDetails.disease.name,
            style: TextStyle(
              fontSize: 24.sp,
              color: primaryColor,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.grey.shade400,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 1.h,
            ),
            child: Text(
              medicalCaseDetails.patientDiagnosis.diagnosisDateTime
                  .getDateOnly(),
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(
            'اسم المريض',
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Text(
            medicalCaseDetails.patient.fullName,
            style: TextStyle(
              fontSize: 14.sp,
              color: secondaryColor,
            ),
          ),
        ],
      ),
      trailing: CustomIconButton(
        iconData: Icons.chat,
        onTap: () => Get.to(
          () => MedicalCaseChatPage(
            medicalCaseDetails: medicalCaseDetails,
          ),
        ),
      ),
    );
  }
}
