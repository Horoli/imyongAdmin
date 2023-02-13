part of '/common.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $loginToken = TStream<String>()..sink$('');

  String get loginToken => $loginToken.lastValue;

  ServiceLogin._internal();

  final Map<String, String> _headers = {
    "Content-Type": "application/json",

    // List<String>? mainCategory,
    // "token": hiveMLogin.values.first.token,
  };

  Future<MLogin> login({required String id, required String pw}) async {
    String encodeData = jsonEncode({"id": id, "pw": pw});

    final response = await http.post(
      getRequestUri(PATH.LOGIN),
      headers: _headers,
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      dynamic getData = jsonDecode(response.body)['data'];
      print(getData);
      MLogin data = MLogin.fromMap(getData);
      $loginToken.sink$(data.token);
      hiveMLogin.put('token', data);
      print(hiveMLogin.toMap());

      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
