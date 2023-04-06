part of 'lib.dart';

class MQuestion extends MCommonBase {
  final String question;
  final String answer;
  final String categoryID;
  final String difficulty;
  final int score;
  final List<String> images;

  MQuestion({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.question,
    required this.answer,
    required this.categoryID,
    required this.difficulty,
    required this.score,
    required this.images,
  });

  @override
  Map<String, dynamic> get map => {
        'question': question,
        'answer': answer,
        'categoryID': categoryID,
        'difficulty': difficulty,
        'score': score,
        'images': images,
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory MQuestion.fromMap(Map item) {
    String id = item['id'] ?? '';
    int createdAt = item['createdAt'] ?? '';
    int updatedAt = item['updatedAt'] ?? '';
    String question = item['question'] ?? '';
    String answer = item['answer'] ?? '';
    String categoryID = item['categoryID'] ?? '';
    String difficulty = item['difficulty'] ?? '';
    int score = item['score'] ?? 0;
    List<String> images = List<String>.from(item['images'] ?? []);

    return MQuestion(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        question: question,
        answer: answer,
        categoryID: categoryID,
        difficulty: difficulty,
        score: score,
        images: images);
  }

  MQuestion copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? question,
    String? answer,
    String? categoryID,
    String? difficulty,
    int? score,
    List<String>? images,
  }) =>
      MQuestion(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        categoryID: categoryID ?? this.categoryID,
        difficulty: difficulty ?? this.difficulty,
        score: score ?? this.score,
        images: images ?? this.images,
      );
}
