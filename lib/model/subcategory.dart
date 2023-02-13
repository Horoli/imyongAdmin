part of '/common.dart';

class MSubCategory {
  final String id;
  final String mainCategory;
  final String subCategory;

  MSubCategory({
    required this.id,
    required this.mainCategory,
    required this.subCategory,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'maincategory': mainCategory,
        'subCategory': subCategory,
      };

  factory MSubCategory.fromMap(Map item) {
    String id = item['id'] ?? '';
    String subCategory = item['subcategory'] ?? '';
    String mainCategory = item['maincategory'] ?? '';

    return MSubCategory(
      id: id,
      mainCategory: mainCategory,
      subCategory: subCategory,
    );
  }

  MSubCategory copyWith({
    String? id,
    String? mainCategory,
    String? subCategory,
  }) =>
      MSubCategory(
        id: id ?? this.id,
        mainCategory: mainCategory ?? this.mainCategory,
        subCategory: subCategory ?? this.subCategory,
      );
}
