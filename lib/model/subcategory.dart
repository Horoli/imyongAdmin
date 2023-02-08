part of '/common.dart';

class MMainCategory {
  late List<String> type;

  MMainCategory({
    required this.type,
  });

  @override
  Map<String, dynamic> get map => {
        'type ': type,
      };

  factory MMainCategory.fromMap(Map item) {
    List<String> type = List<String>.from(item['type'] ?? []);

    return MMainCategory(type: type);
  }

  MMainCategory copyWith({
    List<String>? type,
  }) =>
      MMainCategory(
        type: type ?? this.type,
      );
}
