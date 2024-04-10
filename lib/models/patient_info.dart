// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';

class PatientInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final DateTime dateOfBirth;
  final bool isMale;
  PatientInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dateOfBirth,
    required this.isMale,
  });

  PatientInfo copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    DateTime? dateOfBirth,
    bool? isMale,
  }) {
    return PatientInfo(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isMale: isMale ?? this.isMale,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'dateOfBirth': dateOfBirth.getDateOnly(),
      'isMale': isMale,
    };
  }

  factory PatientInfo.fromMap(Map<String, dynamic> map) {
    return PatientInfo(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      isMale: map['isMale'] as bool,
    );
  }

  String get genderAsArabicText => isMale ? 'ذكر' : 'أنثى';
  String get fullName => '$firstName $lastName';

  String toJson() => json.encode(toMap());

  factory PatientInfo.fromJson(String source) =>
      PatientInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PatientInfo(id: $id, firstName: $firstName, lastName: $lastName, username: $username, dateOfBirth: $dateOfBirth, isMale: $isMale)';
  }

  @override
  bool operator ==(covariant PatientInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.dateOfBirth == dateOfBirth &&
        other.isMale == isMale;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode ^
        dateOfBirth.hashCode ^
        isMale.hashCode;
  }
}
