part of 'lib.dart';

class ServiceMainCategory {
  static ServiceMainCategory? _instance;
  factory ServiceMainCategory.getInstance() =>
      _instance ??= ServiceMainCategory._internal();

  ServiceMainCategory._internal();

  TStream<Map<String, MMainCategory>> $mainCategory =
      TStream<Map<String, MMainCategory>>();

  Map<String, MMainCategory> get getMainCategory => $mainCategory.lastValue;

  Future<RestfulResult> get() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http.get(getRequestUri('category'), headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);

        Map<String, dynamic> item = Map.from(result['data'] ?? {});
        MainCategory main = MainCategory.fromMap(item);
        print(main.map);
        completer.complete(
            RestfulResult(statusCode: STATUS.SUCCESS_CODE, message: 'ok'));
      },
    ).catchError((error) {
      return error;
    });

    return completer.future;
  }

  // TODO : return type을 completer로 수정,
  // TODO : completer 처리 시 token 만료 여부 체크해서 login페이지로 보내는 기능 추가

  // Future<RestfulResult> post({
  //   required String id,
  //   required String type,
  //   required String maincategory,
  //   bool isDelete = false,
  // }) async {
  //   Completer<RestfulResult> completer = Completer<RestfulResult>();

  //   final Map<String, String> _headers = createHeaders(
  //     tokenKey: HEADER.TOKEN,
  //     tokenValue: hiveMLogin.values.first.token,
  //   );

  //   String encodeData = jsonEncode({
  //     "id": id,
  //     "type": type,
  //     "maincategory": maincategory,
  //   });

  //   Future<http.Response> httpResponse = isDelete
  //       ? http.delete(getRequestUri(PATH.MAINCATEGORY),
  //           headers: _headers, body: encodeData)
  //       : http.post(getRequestUri(PATH.MAINCATEGORY),
  //           headers: _headers, body: encodeData);

  //   httpResponse.then((response) {
  //     if (response == null) {
  //       return completer.complete(
  //         RestfulResult(
  //           statusCode: STATUS.UNKNOWN_CODE,
  //           message: STATUS.UNKNOWN_MSG,
  //         ),
  //       );
  //     }
  //     Map result = json.decode(response.body);
  //     if (response.statusCode == STATUS.SUCCESS_CODE) {
  //       Map<String, dynamic> item = Map.from(result['data'] ?? {});
  //       Map<String, MMainCategory> convertItem =
  //           item.map<String, MMainCategory>((key, value) => MapEntry(
  //                 key,
  //                 MMainCategory.fromMap(value),
  //               ));
  //       $mainCategory.sink$(convertItem);
  //     }
  //     return completer.complete(RestfulResult.fromMap(
  //       result,
  //       response.statusCode,
  //     ));
  //   }).catchError(
  //     (error) {
  //       print('Error: $error');
  //       return completer.complete(
  //         RestfulResult(
  //           statusCode: STATUS.CONNECTION_FAILED_CODE,
  //           message: STATUS.CONNECTION_FAILED_MSG,
  //         ),
  //       );
  //     },
  //   );
  //   return completer.future;
  // }

  // Future<RestfulResult> get() async {
  //   Completer<RestfulResult> completer = Completer<RestfulResult>();

  //   http
  //       .get(getRequestUri(PATH.MAINCATEGORY), headers: createHeaders())
  //       .then((response) {
  //     if (response == null) {
  //       return completer.complete(
  //         RestfulResult(
  //           statusCode: STATUS.UNKNOWN_CODE,
  //           message: STATUS.UNKNOWN_MSG,
  //         ),
  //       );
  //     }
  //     if (response.statusCode == STATUS.SUCCESS_CODE) {
  //       Map<String, dynamic> item =
  //           Map.from(jsonDecode(response.body)['data'] ?? {});
  //       Map<String, MMainCategory> convertItem =
  //           item.map<String, MMainCategory>((key, value) => MapEntry(
  //                 key,
  //                 MMainCategory.fromMap(value),
  //               ));
  //       $mainCategory.sink$(convertItem);
  //       return completer.complete(RestfulResult.fromMap(
  //         item,
  //         STATUS.SUCCESS_CODE,
  //       ));
  //     }
  //   }).catchError(
  //     (error) {
  //       print('Error: $error');
  //       return completer.complete(
  //         RestfulResult(
  //           statusCode: STATUS.CONNECTION_FAILED_CODE,
  //           message: STATUS.CONNECTION_FAILED_MSG,
  //         ),
  //       );
  //     },
  //   );
  //   return completer.future;
  // }

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
