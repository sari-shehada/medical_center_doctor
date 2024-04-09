import 'package:flutter/material.dart';
import 'package:medical_center_doctor/core/services/http_service.dart';
import 'package:medical_center_doctor/core/widgets/custom_future_builder.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/new_medical_case.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/widgets/new_medical_case_card.dart';

class NewMedicalCasesPage extends StatefulWidget {
  const NewMedicalCasesPage({super.key});

  @override
  State<NewMedicalCasesPage> createState() => _NewMedicalCasesPageState();
}

class _NewMedicalCasesPageState extends State<NewMedicalCasesPage> {
  late Future<List<NewMedicalCase>> newMedicalCases;

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
        return ListView.builder(
          itemCount: cases.length,
          itemBuilder: (context, index) {
            return NewMedicalCaseCard(
              medicalCase: cases[index],
            );
          },
        );
      },
    );
  }

  Future<List<NewMedicalCase>> getNewMedicalCases() async {
    return await HttpService.parsedMultiGet(
      endPoint: 'medicalCases/',
      mapper: NewMedicalCase.fromMap,
    );
  }
}
