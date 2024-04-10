import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_center_doctor/config/theme/app_colors.dart';
import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';
import 'package:medical_center_doctor/core/ui_utils/custom_divider.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/core/ui_utils/title_details_spaced_widget.dart';
import 'package:medical_center_doctor/pages/medical_case_details_page/medical_case_details_page.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';

class NewMedicalCaseCard extends StatelessWidget {
  const NewMedicalCaseCard({
    super.key,
    required this.medicalCase,
    required this.refreshListCallback,
  });

  final MedicalCaseDetails medicalCase;
  final VoidCallback refreshListCallback;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (await Get.to(
                  () => MedicalCaseDetailsPage(
                    medicalCaseDetails: medicalCase,
                  ),
                ) ==
                true) {
              refreshListCallback();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      medicalCase.disease.name,
                      style: TextStyle(
                        fontSize: 23.sp,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                          AddHorizontalSpacing(value: 8.w),
                          Text(
                            medicalCase.patientDiagnosis.diagnosisDateTime
                                .getDateOnly(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const CustomDivider(),
                Text(
                  'معلومات أخرى',
                  style: TextStyle(
                    fontSize: 17.sp,
                  ),
                ),
                TitleDetailsSpacedWidget(
                  icon: Icons.person,
                  title: 'الجنس',
                  details: medicalCase.patient.genderAsArabicText,
                ),
                TitleDetailsSpacedWidget(
                  icon: Icons.calendar_month,
                  title: 'تاريخ الميلاد',
                  details: medicalCase.patient.dateOfBirth.getDateOnly(),
                ),
                TitleDetailsSpacedWidget(
                  icon: Icons.sticky_note_2,
                  title: 'عدد الأعراض المدخلة',
                  details: medicalCase.symptoms.length.toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
