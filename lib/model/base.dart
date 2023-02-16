part of 'lib.dart';

abstract class MCommonBase extends CommonModel {
  final String id;
  final int createdAt;
  final int updatedAt;
  MCommonBase({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}
