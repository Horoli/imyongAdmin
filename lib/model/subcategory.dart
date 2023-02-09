part of '/common.dart';

class MSubCategory {
  late List<String> subCategory;

  MSubCategory({
    required this.subCategory,
  });

  @override
  Map<String, dynamic> get map => {
        'subcategory': subCategory,
      };

  factory MSubCategory.fromMap(Map item) {
    List<String> subCategory = List<String>.from(item['subcategory'] ?? []);

    return MSubCategory(subCategory: subCategory);
  }

  MSubCategory copyWith({
    List<String>? subCategory,
  }) =>
      MSubCategory(
        subCategory: subCategory ?? this.subCategory,
      );
}
