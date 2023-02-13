part of '/common.dart';

class ServiceMainCategory {
  static ServiceMainCategory? _instance;
  factory ServiceMainCategory.getInstance() =>
      _instance ??= ServiceMainCategory._internal();

  ServiceMainCategory._internal();

  TStream<Map<String, MMainCategory>> $mainCategory =
      TStream<Map<String, MMainCategory>>();

  Map<String, MMainCategory> get getMainCategory => $mainCategory.lastValue;

  Future<Map<String, MMainCategory>> post({
    required String id,
    required String type,
    required String maincategory,
  }) async {
    String encodeData = jsonEncode({
      "id": id,
      "type": type,
      "maincategory": maincategory,
    });

    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      "token": hiveMLogin.values.first.token,
    };

    final response = await http.post(
      getRequestUri(PATH.MAINCATEGORY),
      headers: _headers,
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> item =
          Map.from(jsonDecode(response.body)['data'] ?? {});

      Map<String, MMainCategory> convertItem =
          item.map<String, MMainCategory>((key, value) => MapEntry(
                key,
                MMainCategory.fromMap(value),
              ));

      $mainCategory.sink$(convertItem);

      return convertItem;
    } else {
      throw Exception('failed to load Data');
    }
  }

  Future<Map<String, MMainCategory>> get() async {
    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      // "token": hiveMLogin.values.first.GServiceGuesttoken,
    };

    final response = await http.get(
      getRequestUri(PATH.MAINCATEGORY),
      headers: _headers,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> item =
          Map.from(jsonDecode(response.body)['data'] ?? {});

      Map<String, MMainCategory> convertItem =
          item.map<String, MMainCategory>((key, value) => MapEntry(
                key,
                MMainCategory.fromMap(value),
              ));

      $mainCategory.sink$(convertItem);

      return convertItem;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
