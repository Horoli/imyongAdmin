part of 'lib.dart';

class ServiceMainCategory {
  static ServiceMainCategory? _instance;
  factory ServiceMainCategory.getInstance() =>
      _instance ??= ServiceMainCategory._internal();

  ServiceMainCategory._internal();

  TStream<Map<String, MMainCategory>> $mainCategory =
      TStream<Map<String, MMainCategory>>();

  Map<String, MMainCategory> get getMainCategory => $mainCategory.lastValue;

  // TODO : return type을 completer로 수정,
  // TODO : completer 처리 시 token 만료 여부 체크해서 login페이지로 보내는 기능 추가

  Map<String, String> createHeaders({String? tokenKey, String? tokenValue}) {
    Map<String, String> headers = {
      HEADER.CONTENT_TYPE: HEADER.JSON,
    };
    if (tokenKey != null) {
      headers[tokenKey] = tokenValue!;
    }

    return headers;
  }

  Future<RestfulResult> comPost({
    required String id,
    required String type,
    required String maincategory,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String encodeData = jsonEncode({
      "id": id,
      "type": type,
      "maincategory": maincategory,
    });

    http
        .post(getRequestUri(PATH.MAINCATEGORY),
            headers: _headers, body: encodeData)
        .then((response) {
      if (response == null) {
        return completer.complete(RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: STATUS.UNKNOWN_MSG,
        ));
      }
      Map result = json.decode(response.body);

      if (response.statusCode == STATUS.SUCCESS_CODE) {
        Map<String, dynamic> item = Map.from(result['data'] ?? {});

        Map<String, MMainCategory> convertItem =
            item.map<String, MMainCategory>((key, value) => MapEntry(
                  key,
                  MMainCategory.fromMap(value),
                ));
        $mainCategory.sink$(convertItem);
      }

      return completer.complete(RestfulResult.fromMap(
        result,
        response.statusCode,
      ));
    }).catchError((error) {
      print('Error: $error');
      return completer.complete(
        RestfulResult(
          statusCode: STATUS.CONNECTION_FAILED_CODE,
          message: STATUS.CONNECTION_FAILED_MSG,
        ),
      );
    });

    return completer.future;
  }

  Future<Map<String, MMainCategory>> get() async {
    final response = await http.get(
      getRequestUri(PATH.MAINCATEGORY),
      headers: createHeaders(),
    );

    if (response.statusCode != STATUS.SUCCESS_CODE) {
      throw Exception(STATUS.LOAD_FAILED_MSG);
    }

    print('response $response');
    print('responseBody ${response.body}');

    Map<String, dynamic> item =
        Map.from(jsonDecode(response.body)['data'] ?? {});

    Map<String, MMainCategory> convertItem =
        item.map<String, MMainCategory>((key, value) => MapEntry(
              key,
              MMainCategory.fromMap(value),
            ));

    $mainCategory.sink$(convertItem);

    return convertItem;
  }

  // Future<Map<String, MMainCategory>> post({
  //   required String id,
  //   required String type,
  //   required String maincategory,
  // }) async {
  //   String encodeData = jsonEncode({
  //     "id": id,
  //     "type": type,
  //     "maincategory": maincategory,
  //   });

  //   final Map<String, String> _headers = {
  //     HEADER.CONTENT_TYPE: HEADER.JSON,
  //     HEADER.TOKEN: hiveMLogin.values.first.token,
  //   };

  //   final http.Response response = await http.post(
  //     getRequestUri(PATH.MAINCATEGORY),
  //     headers: _headers,
  //     body: encodeData,
  //   );

  //   print('response ${response.body}');

  //   if (response.statusCode != STATUS.SUCCESS_CODE) {
  //     throw Exception(STATUS.LOAD_FAILED_MSG);
  //   }

  //   print('response $response');
  //   print('responseBody ${response.body}');

  //   Map<String, dynamic> item =
  //       Map.from(jsonDecode(response.body)['data'] ?? {});

  //   Map<String, MMainCategory> convertItem =
  //       item.map<String, MMainCategory>((key, value) => MapEntry(
  //             key,
  //             MMainCategory.fromMap(value),
  //           ));

  //   $mainCategory.sink$(convertItem);

  //   return convertItem;
  // }
}
