part of '/common.dart';

// @HiveType(typeId: HIVE_ID.GUEST)
// TODO : move to imyong APP
class MGuest extends MCommonBase {
  late List<String> currentQuestion;
  late List<String> wrongQuestion;
  MGuest._internal({
    required this.currentQuestion,
    required this.wrongQuestion,
    required super.id,
    required super.createdAt,
    required super.updatedAt,
  });
  // }) : this.tmp = tmp == 0 ? 1 : tmp;

  factory MGuest.fromMap(Map<String, dynamic> item) {
    String id = item['id'] ?? '';
    int createdAt = item['createdAt'] ?? 0;
    int updatedAt = item['updatedAt'] ?? 0;
    List<String> currentQuestion =
        List<String>.from(item['currentQuestion'] ?? []);
    List<String> wrongQuestion = List<String>.from(item['wrongQuestion'] ?? []);

    return MGuest._internal(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
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

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    // "token": hiveMLogin.values.first.token,
  };

  TStream<Map<String, MGuest>> $guest = TStream<Map<String, MGuest>>();

  Map<String, MGuest> get getGuest => $guest.lastValue;

  // TODO :
  Future<MGuest> post({required String uuid}) async {
    String encodeData = jsonEncode({"id": uuid});

    final response = await http.post(
      getRequestUri(PATH.GUEST),
      headers: _headers,
      body: encodeData,
    );

    print('response $response');
    print('responseBody ${response.body}');

    if (response.statusCode == 200) {
      dynamic getData = jsonDecode(response.body)['data'];
      print(getData);
      MGuest data = MGuest.fromMap(getData);
      return data;
    } else {
      throw Exception('failed to load Data');
    }
  }

  Future<Map<String, MGuest>> get() async {
    final response = await http.get(
      getRequestUri(PATH.GUEST),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('failed to load Data');
    }

    Map<String, dynamic> item =
        Map.from(jsonDecode(response.body)['data']['guest'] ?? {});

    Map<String, MGuest> convertedItem = item.map<String, MGuest>(
        (key, value) => MapEntry(key, MGuest.fromMap(value)));

    $guest.sink$(convertedItem);
    return convertedItem;
  }
}
