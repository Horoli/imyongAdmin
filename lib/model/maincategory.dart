
part of '/common.dart';

class MSubCategory {
  late List<String> type;

  MSubCategory({
    required this.type,
  });

  @override
  Map<String, dynamic> get map => {
        'type ': type,
      };

  factory MSubCategory.fromMap(Map item) {
    List<String> type = List<String>.from(item['type'] ?? []);

    return MSubCategory(type: type);
  }

  MSubCategory copyWith({
    List<String>? type,
  }) =>
      MSubCategory(
        type: type ?? this.type,
      );
}
