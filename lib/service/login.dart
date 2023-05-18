part of 'lib.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $token = TStream<String>()..sink$('');

  String get token => $token.lastValue;

  ServiceLogin._internal();

  // void hiveBoxlistener() {
  //   hiveMLogin.watch().listen((event) {
  //     print('event $event');
  //   });
  // }

  Future<RestfulResult> Post(String id, String pw) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    String encodeData = jsonEncode({"id": id, "pw": pw});

    http
        .post(getRequestUri(PATH.LOGIN),
            headers: createHeaders(), body: encodeData)
        .then((response) {
      if (response.isNull) {
        return completer.complete(RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: STATUS.UNKNOWN_MSG,
        ));
      }
      Map result = json.decode(response.body);
      print('result $result');

      if (response.statusCode == STATUS.SUCCESS_CODE) {
        print('bbbbb');
        MLogin convertedItem = MLogin.fromMap(result['data'] ?? {});
        $token.sink$(convertedItem.token);
        localStorage.setItem(PATH.STORAGE_TOKEN, convertedItem.token);
      } else {
        print('aaaaaaaaaaaaaaaaaaaaaaaa');
        localStorage.setItem(PATH.STORAGE_TOKEN, '');
        // hiveMLogin.put(id, MLogin(token: ''));
      }

      // print('hiveMLogin.keys ${hiveMLogin.keys}');
      // print('hiveMLogin.value ${hiveMLogin.values}');

      return completer.complete(RestfulResult.fromMap(
        result,
        response.statusCode,
      ));
    }).catchError((error) {
      print('Error: $error');

      GHelperNavigator.pushLogin();
      return completer.complete(
        RestfulResult(
          statusCode: STATUS.CONNECTION_FAILED_CODE,
          message: STATUS.CONNECTION_FAILED_MSG,
        ),
      );
    }).timeout(
      const Duration(milliseconds: 5000),
      onTimeout: () => completer.complete(
        RestfulResult(
          statusCode: STATUS.CONNECTION_FAILED_CODE,
          message: STATUS.REQUEST_TIMEOUT,
        ),
      ),
    );

    return completer.future;
  }
}
