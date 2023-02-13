part of '/common.dart';

class MMainCategory {
  // late List<String> mainCategory;
  final String id;
  final String type;
  final String mainCategory;

  MMainCategory({
    required this.id,
    required this.mainCategory,
    required this.type,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'type': type,
        'maincategory': mainCategory,
      };

  factory MMainCategory.fromMap(Map item) {
    String id = item['id'] ?? '';
    String type = item['type'] ?? '';
    String mainCategory = item['maincategory'] ?? '';

    return MMainCategory(
      id: id,
      type: type,
      mainCategory: mainCategory,
    );
  }

  MMainCategory copyWith({
    String? id,
    String? type,
    String? mainCategory,
  }) =>
      MMainCategory(
        id: id ?? this.id,
        type: type ?? this.type,
        mainCategory: mainCategory ?? this.mainCategory,
      );
}
