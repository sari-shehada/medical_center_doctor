import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/pages/my_medical_cases_page/widgets/empty_medical_case_widget.dart';
import 'package:medical_center_doctor/pages/my_medical_cases_page/widgets/patient_medical_case_card.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import '../../../core/ui_utils/spacing_utils.dart';
import '../../../managers/medical_cases_manager.dart';

class MedicalCaseListViewWidget extends StatelessWidget {
  const MedicalCaseListViewWidget({
    super.key,
    required this.cases,
    required this.isEnded,
  });

  final List<MedicalCaseDetails> cases;
  final bool isEnded;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => MedicalCasesManager.instance.updateList(),
      child: cases.isEmpty
          ? EmptyMedicalCasesWidget(
              isEnded: isEnded,
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: 5.h,
                horizontal: 5.w,
              ),
              itemCount: cases.length,
              itemBuilder: (context, index) => PatientMedicalCaseCard(
                medicalCaseDetails: cases[index],
              ),
              separatorBuilder: (context, index) =>
                  AddVerticalSpacing(value: 10.h),
            ),
    );
  }
}
