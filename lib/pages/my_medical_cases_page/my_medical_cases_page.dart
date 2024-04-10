import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_center_doctor/core/services/http_service.dart';
import 'package:medical_center_doctor/core/ui_utils/spacing_utils.dart';
import 'package:medical_center_doctor/core/widgets/custom_future_builder.dart';
import 'package:medical_center_doctor/managers/account_manager.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/widgets/new_medical_case_card.dart';

class MyMedicalCasesPage extends StatefulWidget {
  const MyMedicalCasesPage({super.key});

  @override
  State<MyMedicalCasesPage> createState() => _MyMedicalCasesPageState();
}

class _MyMedicalCasesPageState extends State<MyMedicalCasesPage> {
  late Future<List<MedicalCaseDetails>> newMedicalCases;

  @override
  void initState() {
    newMedicalCases = getMyMedicalCases();
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

  Future<List<MedicalCaseDetails>> getMyMedicalCases() async {
    int docId = AccountManager.instance.user!.id;
    return await HttpService.parsedMultiGet(
      endPoint: 'doctors/$docId/medicalCases/',
      mapper: MedicalCaseDetails.fromMap,
    );
  }

  void updateList() {
    newMedicalCases = getMyMedicalCases();
    setState(() {});
  }
}
