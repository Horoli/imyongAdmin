part of 'lib.dart';

// @HiveType(typeId: HIVE_ID.GUEST)
// TODO : move to imyong APP
class MGuest extends MCommonBase {
  final List<String> wishQuestion;
  final List<String> currentQuestion;
  final List<String> wrongQuestion;
  MGuest._internal({
    required this.wishQuestion,
    required this.currentQuestion,
    required this.wrongQuestion,
    required super.id,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MGuest.fromMap(Map<String, dynamic> item) {
    String id = item['id'] ?? '';
    List<String> wishQuestion = List<String>.from(item['wishQuestion'] ?? []);
    int createdAt = item['createdAt'] ?? 0;
    int updatedAt = item['updatedAt'] ?? 0;
    List<String> currentQuestion =
        List<String>.from(item['currentQuestion'] ?? []);
    List<String> wrongQuestion = List<String>.from(item['wrongQuestion'] ?? []);

    return MGuest._internal(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      wishQuestion: wishQuestion,
      currentQuestion: currentQuestion,
      wrongQuestion: wrongQuestion,
    );
  }

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'currentQuestion': currentQuestion,
        'wrongQuestion': wrongQuestion,
      };
}

class ServiceGuest {
  static ServiceGuest? _instance;
  factory ServiceGuest.getInstance() => _instance ??= ServiceGuest._internal();

  ServiceGuest._internal();

  TStream<String> $testToken = TStream<String>();
  String get testToken => $testToken.lastValue;

  // TODO : change http.post to completer
  Future<RestfulResult> post({required String uuid}) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();
    String encodeData = jsonEncode({"id": uuid});

    http
        .post(getRequestUri(PATH.GUEST),
            headers: createHeaders(), body: encodeData)
        .then((response) {
      Map<String, dynamic> item =
          Map.from(jsonDecode(response.body)['data'] ?? {});
      print('item $item');

      $testToken.sink$(item['token'].toString());
    });
    return completer.future;
  }

  Future<RestfulResult> get(String testID) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    print('testID $testID');
    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: testID,
    );

    // TODO : test
    String query = 'guest?id=$uid';

    http.get(getRequestUri(query), headers: _headers).then((response) {
      print('get ${response.body}');
    });

    // if (response.statusCode != STATUS.SUCCESS_CODE) {
    //   throw Exception(STATUS.LOAD_FAILED_MSG);
    // }

    // Map<String, dynamic> item =
    //     Map.from(jsonDecode(response.body)['data']['guest'] ?? {});

    // Map<String, MGuest> convertedItem = item.map<String, MGuest>(
    //     (key, value) => MapEntry(key, MGuest.fromMap(value)));

    // $guest.sink$(convertedItem);
    return completer.future;
  }
}
