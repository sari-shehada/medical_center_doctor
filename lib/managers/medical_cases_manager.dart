import 'package:flutter/material.dart';
import 'package:medical_center_doctor/pages/new_medical_cases_page/models/medical_case_details.dart';
import '../models/separated_medical_cases.dart';
import '../core/services/http_service.dart';
import 'account_manager.dart';

class MedicalCasesManager with ChangeNotifier {
  MedicalCasesManager._() {
    AccountManager.instance.addListener(
      () {
        if (!AccountManager.instance.isLoggedIn) {
          _medicalCases = null;
        }
      },
    );
  }

  static MedicalCasesManager instance = MedicalCasesManager._();

  Future<SeparatedMedicalCases> get medicalCases => _getValue();

  Future<SeparatedMedicalCases> _getValue() {
    _medicalCases ??= getMedicalCases();
    return _medicalCases!;
  }

  Future<SeparatedMedicalCases>? _medicalCases;

  Future<SeparatedMedicalCases> getMedicalCases() async {
    final int? userId = AccountManager.instance.user?.id;
    if (userId == null) {
      throw Exception('User id is null');
    }
    List<MedicalCaseDetails> result = await HttpService.parsedMultiGet(
      endPoint: 'doctors/$userId/medicalCases/',
      mapper: MedicalCaseDetails.fromMap,
    );
    result.sort(
      (a, b) => b.patientDiagnosis.diagnosisDateTime.compareTo(
        a.patientDiagnosis.diagnosisDateTime,
      ),
    );

    var currentCases = result
        .where((element) => element.medicalCase.status != 'ended')
        .toList();
    currentCases.sort(
      (a, b) => a.medicalCase.status.compareTo(b.medicalCase.status),
    );

    return SeparatedMedicalCases(
      currentCases: currentCases.reversed.toList(),
      endedCases: result
          .where((element) => element.medicalCase.status == 'ended')
          .toList(),
    );
  }

  void updateList() {
    _medicalCases = getMedicalCases();
    notifyListeners();
  }
}
