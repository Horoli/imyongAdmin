part of 'lib.dart';

class ServiceQuestion {
  static ServiceQuestion? _instance;
  factory ServiceQuestion.getInstance() =>
      _instance ??= ServiceQuestion._internal();

  ServiceQuestion._internal();

  Future<RestfulResult> post({
    String question = 'question',
    String answer = 'answer',
    String category = 'categoryID',
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
      "category": category,
      "difficulty": difficulty,
      "score": score,
    });

    http
        .post(getRequestUri(PATH.QUESTION),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);
      print('result $result');
    });

    //
    return completer.future;
  }
}
