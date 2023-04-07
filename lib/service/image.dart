part of 'lib.dart';

class ServiceImage {
  static ServiceImage? _instance;
  factory ServiceImage.getInstance() => _instance ??= ServiceImage._internal();

  ServiceImage._internal();

  final TStream<List<String>> $images = TStream<List<String>>();
}
