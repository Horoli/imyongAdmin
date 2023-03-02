part of 'lib.dart';

class MSubCategory extends MCommonBase {
  final String name;
  final String parent;
  final List<String> children;

  MSubCategory({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.parent,
    required this.children,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'name': name,
        'parent': parent,
        'children': children,
      };

  factory MSubCategory.fromMap(Map item) {
    String id = item['id'] ?? '';
    int createdAt = item['createdAt'] ?? '';
    int updatedAt = item['updatedAt'] ?? '';
    String name = item['name'] ?? '';
    String parent = item['parent'] ?? '';
    List<String> children = List<String>.from(item['children'] ?? []);

    return MSubCategory(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      parent: parent,
      children: children,
    );
  }

  MSubCategory copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? name,
    String? parent,
    List<String>? children,
  }) =>
      MSubCategory(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        parent: parent ?? this.parent,
        children: children ?? this.children,
      );
}
