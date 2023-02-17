part of 'lib.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $loginToken = TStream<String>()..sink$('');

  String get loginToken => $loginToken.lastValue;

  ServiceLogin._internal();

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    // "token": hiveMLogin.values.first.token,
  };

  void hiveBoxlistener() {
    hiveMLogin.watch().listen((event) {
      print('event $event');
    });
  }

  Future<MLogin> post({required String id, required String pw}) async {
    String encodeData = jsonEncode({"id": id, "pw": pw});

    final response = await http.post(
      getRequestUri(PATH.LOGIN),
      headers: _headers,
      body: encodeData,
    );

    if (response.statusCode != 200) {
      // print('response ${response.statusCode}');
      // hiveMLogin.put('token', MLogin(token: ''));
      // print(hiveMLogin.values);
      throw Exception('failed to load Data');
    }

    print('response $response');
    print('responseBody ${response.body}');

    MLogin convertedItem =
        MLogin.fromMap(jsonDecode(response.body)['data'] ?? {});
    $loginToken.sink$(convertedItem.token);
    hiveMLogin.put('token', convertedItem);
    print(hiveMLogin.toMap());

    return convertedItem;
  }
}
