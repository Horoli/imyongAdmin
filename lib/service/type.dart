part of 'lib.dart';

class ServiceType {
  static ServiceType? _instance;
  factory ServiceType.getInstance() => _instance ??= ServiceType._internal();

  ServiceType._internal();

  TStream<MType> $type = TStream<MType>();

  MType get type => $type.lastValue;

  Future<RestfulResult> postDel({
    required String type,
    bool isDelete = false,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String encodeData = jsonEncode({"type": type});

    Future<http.Response> httpResponse = isDelete
        ? http.delete(getRequestUri(PATH.TYPE),
            headers: _headers, body: encodeData)
        : http.post(getRequestUri(PATH.TYPE),
            headers: _headers, body: encodeData);

    httpResponse.then((response) {
      if (response == null) {
        return completer.complete(
          RestfulResult(
            statusCode: STATUS.UNKNOWN_CODE,
            message: STATUS.UNKNOWN_MSG,
          ),
        );
      }
      Map result = jsonDecode(response.body);

      if (response.statusCode == STATUS.SUCCESS_CODE) {
        MType convertedItem = MType.fromMap(result['data'] ?? {});
        $type.sink$(convertedItem);
      }
      return completer.complete(RestfulResult(
        statusCode: response.statusCode,
        data: result,
        message: '',
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

  Future<RestfulResult> get({bool isCategoryView = false}) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    http
        .get(getRequestUri(PATH.TYPE), headers: createHeaders())
        .then((response) {
      if (response == null) {
        return completer.complete(
          RestfulResult(
            statusCode: STATUS.UNKNOWN_CODE,
            message: STATUS.UNKNOWN_MSG,
          ),
        );
      }

      Map result = jsonDecode(response.body);

      if (response.statusCode == STATUS.SUCCESS_CODE) {
        MType convertedItem = MType.fromMap(result['data'] ?? {});

        // TODO : type을 선택할 경우, 빈값을 선택 할 수 있도록 0번째에 빈값을 추가
        if (isCategoryView) {
          convertedItem.type.insert(0, '');
        }
        $type.sink$(convertedItem);
      }

      return completer.complete(RestfulResult(
        statusCode: response.statusCode,
        data: result,
        message: '',
      ));
    }).catchError(
      (error) {
        print('Error: $error');
        return completer.complete(
          RestfulResult(
            statusCode: STATUS.CONNECTION_FAILED_CODE,
            message: STATUS.CONNECTION_FAILED_MSG,
          ),
        );
      },
    );
    return completer.future;
  }
}
