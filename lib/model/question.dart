part of 'lib.dart';

class MQuestion extends MCommonBase {
  MQuestion({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory MQuestion.fromMap(Map item) {
    String id = item['id'] ?? '';
    int createdAt = item['createdAt'] ?? '';
    int updatedAt = item['updatedAt'] ?? '';

    return MQuestion(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MQuestion copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
  }) =>
      MQuestion(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
