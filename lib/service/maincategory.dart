part of '/common.dart';

class ServiceMainCategory {
  static ServiceMainCategory? _instance;
  factory ServiceMainCategory.getInstance() =>
      _instance ??= ServiceMainCategory._internal();

  ServiceMainCategory._internal();

  TStream<MMainCategory> $mainCategory = TStream<MMainCategory>();

  MMainCategory get getMainCategory => $mainCategory.lastValue;

  Future<MMainCategory> get() async {
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
      dynamic getData = jsonDecode(response.body)['data'];
      //
      MMainCategory data = MMainCategory.fromMap(getData);
      $mainCategory.sink$(data);
      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
