part of 'lib.dart';

class ServiceType {
  static ServiceType? _instance;
  factory ServiceType.getInstance() => _instance ??= ServiceType._internal();

  ServiceType._internal();

  TStream<MType> $type = TStream<MType>();

  MType get type => $type.lastValue;

  Future<MType> get() async {
    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      // "token": hiveMLogin.values.first.GServiceGuesttoken,
    };

    final response = await http.get(
      getRequestUri(PATH.TYPE),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('failed to load Data');
    }

    MType convertedItem =
        MType.fromMap(jsonDecode(response.body)['data'] ?? {});

    // TODO : type을 선택할 경우, 빈값을 선택 할 수 있도록 0번째에 빈값을 추가
    convertedItem.type.insert(0, '');
    $type.sink$(convertedItem);
    return convertedItem;
  }

  Future<MType> postDel({
    required String type,
    bool del = false,
  }) async {
    String encodeData = jsonEncode({"type": type});

    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      "token": hiveMLogin.values.first.token,
    };

    late final response;

    if (del) {
      response = await http.delete(
        getRequestUri(PATH.TYPE),
        headers: _headers,
        body: encodeData,
      );
    }

    if (del == false) {
      response = await http.post(
        getRequestUri(PATH.TYPE),
        headers: _headers,
        body: encodeData,
      );
    }

    if (response.statusCode != 200) {
      String error = response.body;
      throw Exception(error);
    }

    print('response $response');
    print('responseBody ${response.body}');

    MType convertedItem =
        MType.fromMap(jsonDecode(response.body)['data'] ?? {});
    $type.sink$(convertedItem);
    return convertedItem;
  }
}
