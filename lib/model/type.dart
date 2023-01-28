part of '/common.dart';

class MType {
  late List<String> type;

  MType({
    required this.type,
  });

  @override
  Map<String, dynamic> get map => {
        'type ': type,
      };

  factory MType.fromJson(Map item) {
    List<String> type = List<String>.from(item['type'] ?? []);

    return MType(type: type);
  }

  MType copyWith({
    List<String>? type,
  }) =>
      MType(
        type: type ?? this.type,
      );
}
