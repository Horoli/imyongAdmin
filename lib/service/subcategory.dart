part of '/common.dart';

class ServiceSubCategory {
  static ServiceSubCategory? _instance;
  factory ServiceSubCategory.getInstance() =>
      _instance ??= ServiceSubCategory._internal();

  ServiceSubCategory._internal();

  TStream<Map<String, MSubCategory>> $subCategory =
      TStream<Map<String, MSubCategory>>();

  Map<String, MSubCategory> get getSubCategory => $subCategory.lastValue;

  Future<Map<String, MSubCategory>> post({
    required String id,
    required String subcategory,
    required String maincategory,
  }) async {
    String encodeData = jsonEncode({
      "id": id,
      "maincategory": maincategory,
      "subcategory": subcategory,
    });

    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      "token": hiveMLogin.values.first.token,
    };

    final response = await http.post(
      getRequestUri(PATH.SUBCATEGORY),
      headers: _headers,
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> item =
          Map.from(jsonDecode(response.body)['data'] ?? {});

      Map<String, MSubCategory> convertItem =
          item.map<String, MSubCategory>((key, value) => MapEntry(
                key,
                MSubCategory.fromMap(value),
              ));

      $subCategory.sink$(convertItem);

      return convertItem;
    } else {
      throw Exception('failed to load Data');
    }
  }

  ///
  ///
  Future<Map<String, MSubCategory>> get() async {
    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      "token": hiveMLogin.values.first.token,
    };

    final response = await http.get(
      getRequestUri(PATH.SUBCATEGORY),
      headers: _headers,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> item =
          Map.from(jsonDecode(response.body)['data'] ?? {});
      //
      Map<String, MSubCategory> convertItem =
          item.map<String, MSubCategory>((key, value) => MapEntry(
                key,
                MSubCategory.fromMap(value),
              ));
      $subCategory.sink$(convertItem);
      return convertItem;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
