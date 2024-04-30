// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CaseMessage {
  final int id;
  final String message;
  final String urgencyLevel;
  final DateTime sentAt;
  final bool senderIsDoctor;
  final int caseId;
  CaseMessage({
    required this.id,
    required this.message,
    required this.urgencyLevel,
    required this.sentAt,
    required this.senderIsDoctor,
    required this.caseId,
  });

  CaseMessage copyWith({
    int? id,
    String? message,
    String? urgencyLevel,
    DateTime? sentAt,
    bool? senderIsDoctor,
    int? caseId,
  }) {
    return CaseMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      sentAt: sentAt ?? this.sentAt,
      senderIsDoctor: senderIsDoctor ?? this.senderIsDoctor,
      caseId: caseId ?? this.caseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'urgencyLevel': urgencyLevel,
      'senderIsDoctor': senderIsDoctor,
      'caseId': caseId,
    };
  }

  factory CaseMessage.fromMap(Map<String, dynamic> map) {
    return CaseMessage(
      id: map['id'] as int,
      message: map['message'] as String,
      urgencyLevel: map['urgencyLevel'] as String,
      sentAt: DateTime.parse(map['sentAt']),
      senderIsDoctor: map['senderIsDoctor'] as bool,
      caseId: map['caseId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CaseMessage.fromJson(String source) =>
      CaseMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CaseMessage(id: $id, message: $message, urgencyLevel: $urgencyLevel, sentAt: $sentAt, senderIsDoctor: $senderIsDoctor, caseId: $caseId)';
  }

  @override
  bool operator ==(covariant CaseMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.urgencyLevel == urgencyLevel &&
        other.sentAt == sentAt &&
        other.senderIsDoctor == senderIsDoctor &&
        other.caseId == caseId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        urgencyLevel.hashCode ^
        sentAt.hashCode ^
        senderIsDoctor.hashCode ^
        caseId.hashCode;
  }
}
