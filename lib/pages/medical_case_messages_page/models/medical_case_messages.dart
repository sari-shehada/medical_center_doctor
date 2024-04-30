// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:medical_center_doctor/pages/medical_case_messages_page/models/case_message.dart';

class MedicalCaseMessages {
  final List<CaseMessage> messages;
  final bool hasEnded;
  MedicalCaseMessages({
    required this.messages,
    required this.hasEnded,
  });

  MedicalCaseMessages copyWith({
    List<CaseMessage>? messages,
    bool? hasEnded,
  }) {
    return MedicalCaseMessages(
      messages: messages ?? this.messages,
      hasEnded: hasEnded ?? this.hasEnded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages.map((x) => x.toMap()).toList(),
      'hasEnded': hasEnded,
    };
  }

  factory MedicalCaseMessages.fromMap(Map<String, dynamic> map) {
    return MedicalCaseMessages(
      messages: List<CaseMessage>.from(
        (map['messages'] as List).map<CaseMessage>(
          (x) => CaseMessage.fromMap(x as Map<String, dynamic>),
        ),
      ),
      hasEnded: map['hasEnded'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalCaseMessages.fromJson(String source) =>
      MedicalCaseMessages.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MedicalCaseMessages(messages: $messages, hasEnded: $hasEnded)';

  @override
  bool operator ==(covariant MedicalCaseMessages other) {
    if (identical(this, other)) return true;

    return listEquals(other.messages, messages) && other.hasEnded == hasEnded;
  }

  @override
  int get hashCode => messages.hashCode ^ hasEnded.hashCode;
}
