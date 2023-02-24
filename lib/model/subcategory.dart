part of 'lib.dart';

class MSubCategory extends MCommonBase {
  final String parent;
  final List<String> children;
  final String name;

  MSubCategory({
    required this.parent,
    required this.name,
    required this.children,
    required super.id,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'parent': parent,
        'children': children,
        'name': name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory MSubCategory.fromMap(Map item) {
    String id = item['id'] ?? '';
    String parent = item['parent'] ?? '';
    List<String> children = List<String>.from(item['children'] ?? []);
    String name = item['name'] ?? '';
    int createdAt = item['createdAt'] ?? '';
    int updatedAt = item['updatedAt'] ?? '';

    return MSubCategory(
      id: id,
      parent: parent,
      children: children,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MSubCategory copyWith({
    String? id,
    String? parent,
    List<String>? children,
    String? name,
    int? createdAt,
    int? updatedAt,
  }) =>
      MSubCategory(
        id: id ?? this.id,
        parent: parent ?? this.parent,
        children: children ?? this.children,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
