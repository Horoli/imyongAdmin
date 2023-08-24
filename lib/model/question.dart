part of 'lib.dart';

class MQuestion extends MCommonBase {
  final String question;
  final String answer;
  final String categoryId;
  final String difficulty;
  final int score;
  final List<String> imageIds;
  final String info;
  final String description;

  MQuestion({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.difficulty,
    required this.score,
    required this.imageIds,
    required this.info,
    required this.description,
  });

  @override
  Map<String, dynamic> get map => {
        'question': question,
        'answer': answer,
        'categoryId': categoryId,
        'difficulty': difficulty,
        'score': score,
        'imageIds': imageIds,
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'info': info,
        'description': description,
      };

  factory MQuestion.fromMap(Map item) {
    String id = item['id'] ?? '';
    int createdAt = item['createdAt'] ?? '';
    int updatedAt = item['updatedAt'] ?? '';
    String question = item['question'] ?? '';
    String answer = item['answer'] ?? '';
    String categoryId = item['categoryId'] ?? '';
    String difficulty = item['difficulty'] ?? '';
    int score = item['score'] ?? 0;
    List<String> imageIds = List<String>.from(item['imageIds'] ?? []);
    String info = item['info'] ?? '';
    String description = item['description'] ?? '';

    return MQuestion(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      question: question,
      answer: answer,
      categoryId: categoryId,
      difficulty: difficulty,
      score: score,
      imageIds: imageIds,
      info: info,
      description: description,
    );
  }

  MQuestion copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? question,
    String? answer,
    String? categoryId,
    String? difficulty,
    int? score,
    List<String>? imageIds,
    String? info,
    String? description,
  }) =>
      MQuestion(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        categoryId: categoryId ?? this.categoryId,
        difficulty: difficulty ?? this.difficulty,
        score: score ?? this.score,
        imageIds: imageIds ?? this.imageIds,
        info: info ?? this.info,
        description: description ?? this.description,
      );
}
