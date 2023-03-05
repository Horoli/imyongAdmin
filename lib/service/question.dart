part of 'lib.dart';

class ServiceQuestion {
  static ServiceQuestion? _instance;
  factory ServiceQuestion.getInstance() =>
      _instance ??= ServiceQuestion._internal();

  ServiceQuestion._internal();

  TStream<List<MQuestion>> $questions = TStream<List<MQuestion>>();
  List<MQuestion> get questions => $questions.lastValue;

  Future<RestfulResult> post({
    String question = 'question',
    String answer = 'answer',
    required String categoryID,
    String difficulty = 'normal',
    int score = 3,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();
    //

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String _encodeData = jsonEncode({
      "question": question,
      "answer": answer,
      "categoryID": categoryID,
      "difficulty": difficulty,
      "score": score,
    });

    http
        .post(getRequestUri(PATH.QUESTION),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);
      print('result $result');

      get();

      if (result['statusCode'] == 403) {
        GHelperNavigator.pushLogin();
        return Error();
      }
    });

    //
    return completer.future;
  }

  Future<RestfulResult> get() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http.get(getRequestUri(PATH.QUESTION), headers: _headers).then((response) {
      Map result = json.decode(response.body);
      List<MQuestion> questionList = [];
      for (dynamic item in List.from(result['data'])) {
        questionList.add(MQuestion.fromMap(item));
      }
      print('questionList $questionList');
      //
      $questions.sink$(questionList);
      //
      completer.complete(RestfulResult(
        statusCode: STATUS.SUCCESS_CODE,
        message: 'ok',
      ));
    }).catchError((error) {
      print('error $error');
    });

    return completer.future;
  }

  Future<RestfulResult> patch({
    required String id,
    required String question,
    required String answer,
    required String categoryID,
    String difficulty = 'normal',
    int score = 3,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String _encodeData = jsonEncode({
      "id": id,
      "question": question,
      "answer": answer,
      "categoryID": categoryID,
      "difficulty": difficulty,
      "score": score,
    });

    http
        .patch(getRequestUri(PATH.QUESTION),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);
      print('result $result');

      get();

      if (result['statusCode'] == 403) {
        GHelperNavigator.pushLogin();
        return Error();
      }
    });

    return completer.future;
  }
}
