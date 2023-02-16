part of 'lib.dart';

class MType {
  late List<String> type;

  MType({
    required this.type,
  });

  factory MType.fromMap(Map item) {
    List<String> type = List<String>.from(item['type'] ?? []);
    return MType(type: type);
  }

  @override
  Map<String, dynamic> get map => {
        'type ': type,
      };

  MType copyWith({
    List<String>? type,
  }) =>
      MType(
        type: type ?? this.type,
      );
}
