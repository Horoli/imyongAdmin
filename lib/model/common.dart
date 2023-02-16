part of 'lib.dart';

abstract class CommonModel {
  Map<String, dynamic> get map;

  @override
  bool operator ==(dynamic other) =>
      (other is CommonModel) && (map.toString() == other.map.toString());
}
