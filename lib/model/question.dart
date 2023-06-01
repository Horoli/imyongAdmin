part of 'lib.dart';

class MQuestion extends MCommonBase {
  final String question;
  final String answer;
  final String categoryID;
  final String difficulty;
  final int score;
  final List<String> imageIDs;
  final String info;
  final String description;

  MQuestion({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.question,
    required this.answer,
    required this.categoryID,
    required this.difficulty,
    required this.score,
    required this.imageIDs,
    required this.info,
    required this.description,
  });

  @override
  Map<String, dynamic> get map => {
        'question': question,
        'answer': answer,
        'categoryID': categoryID,
        'difficulty': difficulty,
        'score': score,
        'imagesIDs': imageIDs,
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
    String categoryID = item['categoryID'] ?? '';
    String difficulty = item['difficulty'] ?? '';
    int score = item['score'] ?? 0;
    List<String> imageIDs = List<String>.from(item['imageIDs'] ?? []);
    String info = item['info'] ?? '';
    String description = item['description'] ?? '';

    return MQuestion(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      question: question,
      answer: answer,
      categoryID: categoryID,
      difficulty: difficulty,
      score: score,
      imageIDs: imageIDs,
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
    String? categoryID,
    String? difficulty,
    int? score,
    List<String>? imageIDs,
    String? info,
    String? description,
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
        imageIDs: imageIDs ?? this.imageIDs,
        info: info ?? this.info,
        description: description ?? this.description,
      );
}
