part of '/common.dart';

class ServiceType {
  static ServiceType? _instance;
  factory ServiceType.getInstance() => _instance ??= ServiceType._internal();

  ServiceType._internal();

  Future<MType> getType() async {
    String url = 'http://localhost:3000/type';

    Uri uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        // 'Content-Type': 'application/json',
        'token': '36c4ab35a13246efaad47c045170c642',
      },
      body: jsonEncode({'type': 'asd'}),
    );
    ;

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      MType asd = MType.fromJson(jsonDecode(response.body));
      return asd;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
