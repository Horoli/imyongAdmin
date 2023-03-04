part of 'lib.dart';

class MDifficulty {
  final String easy;
  final String normal;
  final String hard;
  final String veryHard;
  MDifficulty._internal({
    required this.easy,
    required this.normal,
    required this.hard,
    required this.veryHard,
  });

  @override
  Map<String, dynamic> get map => {
        "easy": easy,
        "normal": normal,
        "hard": hard,
        "veryHard": veryHard,
      };

  factory MDifficulty.fromMap(Map item) {
    String easy = item['easy'] ?? '';
    String normal = item['normal'] ?? '';
    String hard = item['hard'] ?? '';
    String veryHard = item['veryHard'] ?? '';

    return MDifficulty._internal(
      easy: easy,
      normal: normal,
      hard: hard,
      veryHard: veryHard,
    );
  }
}
