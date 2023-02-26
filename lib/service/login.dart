part of 'lib.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $loginToken = TStream<String>()..sink$('');

  String get loginToken => $loginToken.lastValue;

  ServiceLogin._internal();

  // final Map<String, String> _headers = {
  //   HEADER.CONTENT_TYPE: HEADER.JSON,
  //   // "token": hiveMLogin.values.first.token,
  // };

  void hiveBoxlistener() {
    hiveMLogin.watch().listen((event) {
      print('event $event');
    });
  }

  Future<RestfulResult> post(String id, String pw) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    String encodeData = jsonEncode({"id": id, "pw": pw});

    http
        .post(getRequestUri(PATH.LOGIN),
            headers: createHeaders(), body: encodeData)
        .then((response) {
      if (response == null) {
        return completer.complete(RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: STATUS.UNKNOWN_MSG,
        ));
      }
      Map result = json.decode(response.body);

      if (response.statusCode == STATUS.SUCCESS_CODE) {
        MLogin convertedItem = MLogin.fromMap(result['data'] ?? {});
        $loginToken.sink$(convertedItem.token);
        hiveMLogin.put('token', convertedItem);
      } else {
        hiveMLogin.put('token', MLogin(token: ''));
      }

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
