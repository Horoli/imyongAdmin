part of 'lib.dart';

class ServiceLogin {
  static ServiceLogin? _instance;
  factory ServiceLogin.getInstance() => _instance ??= ServiceLogin._internal();

  TStream<String> $loginToken = TStream<String>()..sink$('');

  String get loginToken => $loginToken.lastValue;

  ServiceLogin._internal();

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    // "token": hiveMLogin.values.first.token,
  };

  void hiveBoxlistener() {
    hiveMLogin.watch().listen((event) {
      print('event $event');
    });
  }

  Future<RestfulResult> post(String id, String pw) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    String encodeData = jsonEncode({"id": id, "pw": pw});
    http
        .post(getRequestUri(PATH.LOGIN), headers: _headers, body: encodeData)
        .then((response) {
          if (response == null) {
            return completer.complete(RestfulResult(
              statusCode: 400,
              message: 'unknown error.',
            ));
          }
          Map result = json.decode(response.body);

          if (response.statusCode == 200) {
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
        })
        .catchError(
          (error) => completer.complete(
            RestfulResult(
              statusCode: 503,
              message: 'server connection failed.',
            ),
          ),
        )
        .timeout(
          const Duration(milliseconds: 5000),
          onTimeout: () => completer.complete(
            RestfulResult(
              statusCode: 503,
              message: 'Request Timeout.',
            ),
          ),
        );

    return completer.future;

    // : RestfulResult(
    //     statusCode: 503, message: 'server connection failed.');
    // bool connectionCheck = false;
    // String encodeData = jsonEncode({"id": id, "pw": pw});

    // return await http
    //     .post(getRequestUri(PATH.LOGIN), headers: _headers, body: encodeData)
    //     .catchError((error) {
    //   connectionCheck = false;
    // }).then(
    //   (response) {
    //     late Map result;

    //     if (connectionCheck) {
    //       result = json.decode(response.body);
    //       if (response.statusCode == 200) {
    //         MLogin convertedItem = MLogin.fromMap(result['data'] ?? {});
    //         $loginToken.sink$(convertedItem.token);
    //         hiveMLogin.put('token', convertedItem);
    //       } else {
    //         hiveMLogin.put('token', MLogin(token: ''));
    //       }
    //     }

    //     // if (response.statusCode != 200) {
    //     //   throw Exception('failed to load Data');
    //     // }

    //     return connectionCheck
    //         ? RestfulResult.fromMap(result, response.statusCode)
    //         : RestfulResult(
    //             statusCode: 503, message: 'server connection failed.');
    //   },
    // );
  }
}
