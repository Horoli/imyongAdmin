part of 'lib.dart';

class ServiceQuestion {
  static ServiceQuestion? _instance;
  factory ServiceQuestion.getInstance() =>
      _instance ??= ServiceQuestion._internal();

  ServiceQuestion._internal();

  TStream<List<MQuestion>> $questions = TStream<List<MQuestion>>();
  List<MQuestion> get questions => $questions.lastValue;

  Future<RestfulResult> post({
    required String question,
    required String answer,
    required String categoryID,
    String difficulty = 'normal',
    int score = 3,
    List<String>? images = const [],
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
      "images": images, // post할때는 images를 보냄
    });

    http
        .post(getRequestUri(PATH.QUESTION),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);
      print('post result $result');

      // get();

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
      print('get result $result');
      List<MQuestion> questionList = [];
      for (dynamic item in List.from(result['data'])) {
        print('get item $item');
        questionList.add(MQuestion.fromMap(item));
      }
      //
      $questions.sink$(questionList);
      //
      completer.complete(RestfulResult(
        statusCode: STATUS.SUCCESS_CODE,
        message: 'ok',
      ));
    }).catchError((error) {
      print('question get Error $error');
    });

    return completer.future;
  }

  Future<RestfulResult> getImage(String imageID) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http
        .get(getRequestUri(PATH.QUESTION_IMAGE + imageID), headers: _headers)
        .then((response) {
      String imageResult = base64Encode(response.bodyBytes);

      completer.complete(
        RestfulResult(
          statusCode: STATUS.SUCCESS_CODE,
          message: 'ok',
          data: imageResult,
        ),
      );
    }).catchError((error) {
      print('question get Error $error');
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
    required List<String> images,
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
      "images": images,
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
