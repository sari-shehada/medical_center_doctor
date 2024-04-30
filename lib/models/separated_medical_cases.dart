// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';

class SeparatedMedicalCases {
  final List<MedicalCaseDetails> currentCases;
  final List<MedicalCaseDetails> endedCases;
  SeparatedMedicalCases({
    required this.currentCases,
    required this.endedCases,
  });

  List<MedicalCaseDetails> get allCases => [
        ...currentCases,
        ...endedCases,
      ];
}
