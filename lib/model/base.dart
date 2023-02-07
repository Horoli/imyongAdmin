part of '/common.dart';

abstract class MCommonBase extends CommonModel {
  final String id;
  final String createAt;
  final String updateAt;
  MCommonBase({
    required this.id,
    required this.createAt,
    required this.updateAt,
  });
}
