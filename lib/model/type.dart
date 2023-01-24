part of '/common.dart';

class MType {
  late List<String> type;

  MType({
    required this.type,
  });

  MType.fromJson(Map<String, dynamic> json) {
    type = json['type'];
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
