// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:medical_center_doctor/core/extensions/date_time_extensions.dart';

class DoctorSignUpRequest {
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final DateTime dateOfBirth;
  final DateTime careerStartDate;
  final bool isMale;
  DoctorSignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.dateOfBirth,
    required this.careerStartDate,
    required this.isMale,
  });

  DoctorSignUpRequest copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    DateTime? dateOfBirth,
    DateTime? careerStartDate,
    bool? isMale,
  }) {
    return DoctorSignUpRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      careerStartDate: careerStartDate ?? this.careerStartDate,
      isMale: isMale ?? this.isMale,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'dateOfBirth': dateOfBirth.getDateOnly(),
      'careerStartDate': careerStartDate.getDateOnly(),
      'isMale': isMale,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'DoctorSignUpRequest(firstName: $firstName, lastName: $lastName, username: $username, password: $password, dateOfBirth: $dateOfBirth, careerStartDate: $careerStartDate, isMale: $isMale)';
  }

  @override
  bool operator ==(covariant DoctorSignUpRequest other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.password == password &&
        other.dateOfBirth == dateOfBirth &&
        other.careerStartDate == careerStartDate &&
        other.isMale == isMale;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode ^
        password.hashCode ^
        dateOfBirth.hashCode ^
        careerStartDate.hashCode ^
        isMale.hashCode;
  }

  factory DoctorSignUpRequest.fromMap(Map<String, dynamic> map) {
    return DoctorSignUpRequest(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      careerStartDate:
          DateTime.fromMillisecondsSinceEpoch(map['careerStartDate'] as int),
      isMale: map['isMale'] as bool,
    );
  }

  factory DoctorSignUpRequest.fromJson(String source) =>
      DoctorSignUpRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
