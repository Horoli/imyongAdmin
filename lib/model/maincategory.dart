part of '/common.dart';

class MMainCategory {
  late List<String> mainCategory;

  MMainCategory({
    required this.mainCategory,
  });

  @override
  Map<String, dynamic> get map => {
        'maincategory': mainCategory,
      };

  factory MMainCategory.fromMap(Map item) {
    print('item $item');
    List<String> mainCategory = List<String>.from(item['maincategory'] ?? []);

    return MMainCategory(mainCategory: mainCategory);
  }

  MMainCategory copyWith({
    List<String>? mainCategory,
  }) =>
      MMainCategory(
        mainCategory: mainCategory ?? this.mainCategory,
      );
}
