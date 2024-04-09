// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PatientDiagnosis {
  final int id;
  final DateTime diagnosisDateTime;
  final bool isSubmittedForFurtherFollowup;
  final int diseaseId;
  final int patientId;
  PatientDiagnosis({
    required this.id,
    required this.diagnosisDateTime,
    required this.isSubmittedForFurtherFollowup,
    required this.diseaseId,
    required this.patientId,
  });

  PatientDiagnosis copyWith({
    int? id,
    DateTime? diagnosisDateTime,
    bool? isSubmittedForFurtherFollowup,
    int? diseaseId,
    int? patientId,
  }) {
    return PatientDiagnosis(
      id: id ?? this.id,
      diagnosisDateTime: diagnosisDateTime ?? this.diagnosisDateTime,
      isSubmittedForFurtherFollowup:
          isSubmittedForFurtherFollowup ?? this.isSubmittedForFurtherFollowup,
      diseaseId: diseaseId ?? this.diseaseId,
      patientId: patientId ?? this.patientId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'diagnosisDateTime': diagnosisDateTime.millisecondsSinceEpoch,
      'isSubmittedForFurtherFollowup': isSubmittedForFurtherFollowup,
      'diseaseId': diseaseId,
      'patientId': patientId,
    };
  }

  factory PatientDiagnosis.fromMap(Map<String, dynamic> map) {
    return PatientDiagnosis(
      id: map['id'] as int,
      diagnosisDateTime: DateTime.parse(map['diagnosisDateTime']),
      isSubmittedForFurtherFollowup:
          map['isSubmittedForFurtherFollowup'] as bool,
      diseaseId: map['diseaseId'] as int,
      patientId: map['patientId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientDiagnosis.fromJson(String source) =>
      PatientDiagnosis.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PatientDiagnosis(id: $id, diagnosisDateTime: $diagnosisDateTime, isSubmittedForFurtherFollowup: $isSubmittedForFurtherFollowup, diseaseId: $diseaseId, patientId: $patientId)';
  }

  @override
  bool operator ==(covariant PatientDiagnosis other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.diagnosisDateTime == diagnosisDateTime &&
        other.isSubmittedForFurtherFollowup == isSubmittedForFurtherFollowup &&
        other.diseaseId == diseaseId &&
        other.patientId == patientId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        diagnosisDateTime.hashCode ^
        isSubmittedForFurtherFollowup.hashCode ^
        diseaseId.hashCode ^
        patientId.hashCode;
  }
}
