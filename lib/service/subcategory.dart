part of 'lib.dart';

class ServiceSubCategory {
  static ServiceSubCategory? _instance;
  factory ServiceSubCategory.getInstance() =>
      _instance ??= ServiceSubCategory._internal();

  ServiceSubCategory._internal();

  final TStream<List<MSubCategory>> $subCategory =
      TStream<List<MSubCategory>>();

  List<MSubCategory> get subCategory => $subCategory.lastValue;

  Future<RestfulResult> get({String parent = '', bool isSub = false}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    String query = isSub ? 'subcategory' : '${PATH.CATEGORY_QUERY}$parent';

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http.get(getRequestUri(query), headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);
        List<MSubCategory> subList = [];
        for (dynamic item in List.from(result['data'])) {
          subList.add(MSubCategory.fromMap(item));
        }

        print('subList $subList');
        $subCategory.sink$(subList);

        completer.complete(
            RestfulResult(statusCode: STATUS.SUCCESS_CODE, message: 'ok'));
      },
    );

    return completer.future;
  }

  Future<RestfulResult> post({
    required String name,
    String parent = '',
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String _encodeData = jsonEncode({
      "name": name,
      "parent": parent,
    });

    http
        .post(getRequestUri(PATH.CATEGORY),
            body: _encodeData, headers: _headers)
        .then((response) {
      print(response.body);
    });

    return completer.future;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  // Future<Map<String, MSubCategory>> post({
  //   required String id,
  //   required String subcategory,
  //   required String maincategory,
  // }) async {
  //   String _encodeData = jsonEncode({
  //     "id": id,
  //     "maincategory": maincategory,
  //     "subcategory": subcategory,
  //   });

  //   final Map<String, String> _headers = {
  //     HEADER.CONTENT_TYPE: HEADER.JSON,
  //     HEADER.TOKEN: hiveMLogin.values.first.token,
  //   };

  //   final response = await http.post(
  //     getRequestUri(PATH.SUBCATEGORY),
  //     headers: _headers,
  //     body: _encodeData,
  //   );

  //   if (response.statusCode != STATUS.SUCCESS_CODE) {
  //     throw Exception(STATUS.LOAD_FAILED_MSG);
  //   }

  //   print('response $response');
  //   print('responseBody ${response.body}');

  //   Map<String, dynamic> item =
  //       Map.from(jsonDecode(response.body)['data'] ?? {});

  //   Map<String, MSubCategory> convertedItem =
  //       item.map<String, MSubCategory>((key, value) => MapEntry(
  //             key,
  //             MSubCategory.fromMap(value),
  //           ));

  //   $subCategory.sink$(convertedItem);

  //   return convertedItem;
  // }

  // ///
  // ///
  // Future<Map<String, MSubCategory>> get() async {
  //   final Map<String, String> _headers = {
  //     HEADER.CONTENT_TYPE: HEADER.JSON,
  //     HEADER.TOKEN: hiveMLogin.values.first.token,
  //   };

  //   final response = await http.get(
  //     getRequestUri(PATH.SUBCATEGORY),
  //     headers: _headers,
  //   );

  //   if (response.statusCode != STATUS.SUCCESS_CODE) {
  //     throw Exception(STATUS.LOAD_FAILED_MSG);
  //   }

  //   print('response $response');
  //   print('responseBody ${response.body}');

  //   Map<String, dynamic> item =
  //       Map.from(jsonDecode(response.body)['data'] ?? {});
  //   //
  //   Map<String, MSubCategory> convertedItem = item.map<String, MSubCategory>(
  //       (key, value) => MapEntry(key, MSubCategory.fromMap(value)));

  //   $subCategory.sink$(convertedItem);
  //   return convertedItem;
  // }
}
