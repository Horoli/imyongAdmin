part of '/common.dart';

class ServiceType {
  static ServiceType? _instance;
  factory ServiceType.getInstance() => _instance ??= ServiceType._internal();

  ServiceType._internal();

  Future<MType> getType({required String inputType}) async {
    Uri uri = Uri.parse(URL.URL + URL.TYPE);
    String encodeData = jsonEncode({"type": inputType});

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "token": GServiceLogin.loginToken,
      },
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      dynamic getData = jsonDecode(response.body)['data'];
      print(getData);
      MType data = MType.fromJson(getData);
      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
