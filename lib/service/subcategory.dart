part of '/common.dart';

class ServiceSubCategory {
  static ServiceSubCategory? _instance;
  factory ServiceSubCategory.getInstance() =>
      _instance ??= ServiceSubCategory._internal();

  ServiceSubCategory._internal();

  TStream<MSubCategory> $subCategory = TStream<MSubCategory>();

  MSubCategory get getSubCategory => $subCategory.lastValue;

  Future<MSubCategory> get() async {
    final Map<String, String> _headers = {
      "Content-Type": "application/json",
      // "token": hiveMLogin.values.first.GServiceGuesttoken,
    };

    final response = await http.get(
      getRequestUri(PATH.SUBCATEGORY),
      headers: _headers,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      dynamic getData = jsonDecode(response.body)['data'];
      print(getData);
      //
      MSubCategory data = MSubCategory.fromMap(getData);
      $subCategory.sink$(data);
      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }
}
