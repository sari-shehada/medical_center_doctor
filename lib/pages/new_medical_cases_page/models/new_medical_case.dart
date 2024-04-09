// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:medical_center_doctor/models/disease.dart';
import 'package:medical_center_doctor/models/medical_case.dart';
import 'package:medical_center_doctor/models/patient_diagnosis.dart';
import 'package:medical_center_doctor/models/symptom.dart';

class NewMedicalCase {
  final MedicalCase medicalCase;
  final PatientDiagnosis patientDiagnosis;
  final Disease disease;
  final List<Symptom> symptoms;
  NewMedicalCase({
    required this.medicalCase,
    required this.patientDiagnosis,
    required this.disease,
    required this.symptoms,
  });

  NewMedicalCase copyWith({
    MedicalCase? medicalCase,
    PatientDiagnosis? patientDiagnosis,
    Disease? disease,
    List<Symptom>? symptoms,
  }) {
    return NewMedicalCase(
      medicalCase: medicalCase ?? this.medicalCase,
      patientDiagnosis: patientDiagnosis ?? this.patientDiagnosis,
      disease: disease ?? this.disease,
      symptoms: symptoms ?? this.symptoms,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'medicalCase': medicalCase.toMap(),
      'patientDiagnosis': patientDiagnosis.toMap(),
      'disease': disease.toMap(),
      'symptoms': symptoms.map((x) => x.toMap()).toList(),
    };
  }

  factory NewMedicalCase.fromMap(Map<String, dynamic> map) {
    return NewMedicalCase(
      medicalCase:
          MedicalCase.fromMap(map['medicalCase'] as Map<String, dynamic>),
      patientDiagnosis: PatientDiagnosis.fromMap(
          map['patientDiagnosis'] as Map<String, dynamic>),
      disease: Disease.fromMap(map['disease'] as Map<String, dynamic>),
      symptoms: List<Symptom>.from(
        (map['symptoms'] as List).map<Symptom>(
          (x) => Symptom.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewMedicalCase.fromJson(String source) =>
      NewMedicalCase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewMedicalCase(medicalCase: $medicalCase, patientDiagnosis: $patientDiagnosis, disease: $disease, symptoms: $symptoms)';
  }

  @override
  bool operator ==(covariant NewMedicalCase other) {
    if (identical(this, other)) return true;

    return other.medicalCase == medicalCase &&
        other.patientDiagnosis == patientDiagnosis &&
        other.disease == disease &&
        listEquals(other.symptoms, symptoms);
  }

  @override
  int get hashCode {
    return medicalCase.hashCode ^
        patientDiagnosis.hashCode ^
        disease.hashCode ^
        symptoms.hashCode;
  }
}
