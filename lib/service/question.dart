part of 'lib.dart';

class ServiceQuestion {
  static ServiceQuestion? _instance;
  factory ServiceQuestion.getInstance() =>
      _instance ??= ServiceQuestion._internal();

  ServiceQuestion._internal();

  final TStream<int> $totalQuestionCount = TStream<int>()..sink$(0);
  final TStream<int> $selectedPaginationPage = TStream<int>()..sink$(1);
  final TStream<int> $showPaginationCount = TStream<int>()..sink$(20);

  final TStream<List<MQuestion>> $questions = TStream<List<MQuestion>>()
    ..sink$([]);
  List<MQuestion> get questions => $questions.lastValue;

  Future<RestfulResult> post({
    required String question,
    required String answer,
    required String categoryId,
    required String info,
    String description = '',
    String difficulty = 'normal',
    int score = 3,
    List<String>? images = const [],
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();
    //

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    String _encodeData = jsonEncode({
      "question": question,
      "answer": answer,
      "categoryId": categoryId,
      "difficulty": difficulty,
      "score": score,
      "images": images, // post할때는 images를 보냄
      "info": info,
      "description": description,
    });

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.QUESTION)
        : Uri.https(PATH.FORIEGN_URL, PATH.QUESTION);

    http.post(query, body: _encodeData, headers: _headers).then((response) {
      Map result = json.decode(response.body);

      if (result['statusCode'] != 200) {
        completer.complete(
          RestfulResult(
            statusCode: result['statusCode'],
            message: result['message'],
          ),
        );
        return;
      }

      MQuestion question = MQuestion.fromMap(result['data']);

      completer.complete(
        RestfulResult(
          statusCode: 200,
          message: 'ok',
          data: question,
        ),
      );
    }).catchError((error) {
      print(error);
      print('question post Error $error');
    });

    //
    return completer.future;
  }

  Future<RestfulResult> getPagination({
    required int selectedpaginationPage,
    required int showPaginationCount,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL,
            '${PATH.QUESTION_PAGINATION}/${selectedpaginationPage}/${showPaginationCount}')
        : Uri.https(PATH.FORIEGN_URL,
            '${PATH.QUESTION_PAGINATION}/${selectedpaginationPage}/${showPaginationCount}');
    print('query $query');

    http
        // .get(getRequestUri(PATH.QUESTION_QUERY), headers: _headers)
        .get(query, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);

      int questionCount = int.parse(result['totalQuestionCount'].toString());
      $totalQuestionCount.sink$(questionCount);

      List<MQuestion> questionList = [];
      for (dynamic item in List.from(result['data'])) {
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
      print('question : getPagination Error $error');
    });

    return completer.future;
  }

  Future<RestfulResult> getImage(String imageID) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    Uri query = PATH.IS_LOCAL
        ? Uri.http(
            PATH.LOCAL_URL,
            '${PATH.QUESTION_IMAGE}/${imageID}',
          )
        : Uri.https(
            PATH.FORIEGN_URL,
            '${PATH.QUESTION_IMAGE}/${imageID}',
          );

    http.get(query, headers: _headers).then((response) {
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
    required String categoryId,
    required String info,
    String description = '',
    String difficulty = 'normal',
    int score = 3,
    List<String>? images,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    String _encodeData = jsonEncode({
      "id": id,
      "question": question,
      "answer": answer,
      "categoryId": categoryId,
      "difficulty": difficulty,
      "score": score,
      "images": images ?? [],
      "info": info,
      "description": description,
    });

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.QUESTION)
        : Uri.https(PATH.FORIEGN_URL, PATH.QUESTION);

    http.patch(query, body: _encodeData, headers: _headers).then((response) {
      Map result = json.decode(response.body);

      print('patch result $result');

      // TODO : 입력된 값이 없는 경우 exception 처리
      if (result['statusCode'] != 200) {
        completer.complete(
          RestfulResult(
            statusCode: result['statusCode'],
            message: result['message'],
          ),
        );
        return;
      }

      MQuestion question = MQuestion.fromMap(result['data']);

      completer.complete(
        RestfulResult(
          statusCode: result['statusCode'],
          message: result['message'],
          data: question,
        ),
      );
    }).catchError((error) {
      print('question patch Error $error');
      completer.complete(
        RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: 'error',
        ),
      );
    });

    return completer.future;
  }
}
