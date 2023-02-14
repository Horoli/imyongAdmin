part of '/common.dart';

class MMainCategory {
  final String id;
  final String type;
  final String mainCategory;
  // final String? subCategory;

  MMainCategory({
    required this.id,
    required this.type,
    required this.mainCategory,
    // this.subCategory,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'type': type,
        'maincategory': mainCategory,
        // 'subcategory': subCategory,
      };

  factory MMainCategory.fromMap(Map item) {
    String id = item['id'] ?? '';
    String type = item['type'] ?? '';
    String mainCategory = item['maincategory'] ?? '';
    // String subCategory = item['subcategory'] ?? '';

    return MMainCategory(
      id: id,
      type: type,
      mainCategory: mainCategory,
      // subCategory: subCategory,
    );
  }

  MMainCategory copyWith({
    String? id,
    String? type,
    String? mainCategory,
    // String? subCategory,
  }) =>
      MMainCategory(
        id: id ?? this.id,
        type: type ?? this.type,
        mainCategory: mainCategory ?? this.mainCategory,
        // subCategory: subCategory ?? this.subCategory,
      );
}
