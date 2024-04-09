// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Symptom {
  final int id;
  final String name;
  Symptom({
    required this.id,
    required this.name,
  });

  Symptom copyWith({
    int? id,
    String? name,
  }) {
    return Symptom(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Symptom.fromMap(Map<String, dynamic> map) {
    return Symptom(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Symptom.fromJson(String source) =>
      Symptom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Symptom(id: $id, name: $name)';

  @override
  bool operator ==(covariant Symptom other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
