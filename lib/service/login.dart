part of '/common.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $loginToken = TStream<String>()..sink$('');

  String get loginToken => $loginToken.lastValue;

  ServiceLogin._internal();

  Future<MLogin> login({required String id, required String pw}) async {
    Uri uri = Uri.parse(URL.URL + URL.LOGIN);
    String encodeData = jsonEncode({"id": id, "pw": pw});

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      dynamic getData = jsonDecode(response.body)['data'];
      print(getData);
      MLogin data = MLogin.fromJson(getData);
      $loginToken.sink$(data.token);
      hiveMLogin.put(id, data);
      print(hiveMLogin.toMap());

      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
