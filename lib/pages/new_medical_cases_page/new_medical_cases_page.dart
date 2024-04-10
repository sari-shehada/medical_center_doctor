import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/core/services/http_service.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/core/widgets/custom_future_builder.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/widgets/new_medical_case_card.dart';

class NewMedicalCasesPage extends StatefulWidget {
  const NewMedicalCasesPage({super.key});

  @override
  State<NewMedicalCasesPage> createState() => _NewMedicalCasesPageState();
}

class _NewMedicalCasesPageState extends State<NewMedicalCasesPage> {
  late Future<List<MedicalCaseDetails>> newMedicalCases;

  @override
  void initState() {
    newMedicalCases = getNewMedicalCases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      future: newMedicalCases,
      builder: (context, cases) {
        return RefreshIndicator(
          onRefresh: () async => updateList(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            itemCount: cases.length,
            itemBuilder: (context, index) {
              return NewMedicalCaseCard(
                medicalCase: cases[index],
                refreshListCallback: () => updateList(),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                AddVerticalSpacing(
              value: 10.h,
            ),
          ),
        );
      },
    );
  }

  Future<List<MedicalCaseDetails>> getNewMedicalCases() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'medicalCases/',
      mapper: MedicalCaseDetails.fromMap,
    );
  }

  void updateList() {
    newMedicalCases = getNewMedicalCases();
    setState(() {});
  }
}
