// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_center_doctor/config/map_constants.dart';

class MedicalCase {
  final int id;
  final String status;
  final int diagnosisId;
  final int? takenBy;
  MedicalCase({
    required this.id,
    required this.status,
    required this.diagnosisId,
    required this.takenBy,
  });

  MedicalCase copyWith({
    int? id,
    String? status,
    int? diagnosisId,
    int? takenBy,
  }) {
    return MedicalCase(
      id: id ?? this.id,
      status: status ?? this.status,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      takenBy: takenBy ?? this.takenBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'diagnosisId': diagnosisId,
      'takenBy': takenBy,
    };
  }

  factory MedicalCase.fromMap(Map<String, dynamic> map) {
    return MedicalCase(
      id: map['id'] as int,
      status: map['status'] as String,
      diagnosisId: map['diagnosisId'] as int,
      takenBy: map['takenBy'] != null ? map['takenBy'] as int : null,
    );
  }

  String get statusInterpretation => MapConstants.medicalCaseStatus[status]!;

  String toJson() => json.encode(toMap());

  factory MedicalCase.fromJson(String source) =>
      MedicalCase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedicalCase(id: $id, status: $status, diagnosisId: $diagnosisId, takenBy: $takenBy)';
  }

  @override
  bool operator ==(covariant MedicalCase other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.status == status &&
        other.diagnosisId == diagnosisId &&
        other.takenBy == takenBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        diagnosisId.hashCode ^
        takenBy.hashCode;
  }
}
