part of 'lib.dart';

class RestfulResult extends CommonModel {
  final int statusCode;
  final String message;
  final dynamic data;
  bool get isSuccess => statusCode == 200;
  bool hasData;

  RestfulResult({
    required this.statusCode,
    required this.message,
    this.data,
    this.hasData = false,
  });

  @override
  Map<String, dynamic> get map => {
        'statusCode': statusCode,
        'message': message,
        'data': data,
      };

  factory RestfulResult.fromMap(Map item, int statusCode) {
    String message = item['message'] ?? '';
    bool hasData = item.containsKey('data');
    dynamic data = hasData ? item['data'] : {};

    return RestfulResult(
      statusCode: statusCode,
      message: message,
      data: data,
      hasData: hasData,
    );
  }
}
