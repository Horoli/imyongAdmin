part of 'lib.dart';

class ServiceDifficulty {
  static ServiceDifficulty? _instance;
  factory ServiceDifficulty.getInstance() =>
      _instance ??= ServiceDifficulty._internal();

  ServiceDifficulty._internal();

  TStream<MDifficulty> $difficulty = TStream<MDifficulty>();
  MDifficulty get difficulty => $difficulty.lastValue;

  Future<RestfulResult> get() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.DIFFICULTY)
        : Uri.https(PATH.FORIEGN_URL, PATH.DIFFICULTY);

    http.get(query, headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);

        if (result['statusCode'] == 403) {
          GHelperNavigator.pushLogin();
          return Error();
        }

        Map<String, dynamic> item = Map.from(result['data'] ?? {});
        MDifficulty difficulty = MDifficulty.fromMap(item);

        $difficulty.sink$(difficulty);

        completer.complete(RestfulResult(
          statusCode: STATUS.SUCCESS_CODE,
          message: 'ok',
        ));
      },
    ).catchError((error) {
      // TODO : server가 실행 중이지 않으면 login페이지로 이동
      GHelperNavigator.pushLogin();
      print('error $error');
      return error;
    });

    return completer.future;
  }
}
