part of 'lib.dart';

class ServiceSubCategory {
  static ServiceSubCategory? _instance;
  factory ServiceSubCategory.getInstance() =>
      _instance ??= ServiceSubCategory._internal();

  ServiceSubCategory._internal();

  final TStream<List<MSubCategory>> $subCategory =
      TStream<List<MSubCategory>>();

  List<MSubCategory> get subCategory => $subCategory.lastValue;

  Future<RestfulResult> get({String parent = '', bool isSub = false}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    // parent가 없으면 isSub가 true, 있으면 false로 사용
    String query = isSub ? 'subcategory' : '${PATH.CATEGORY_QUERY}$parent';

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http.get(getRequestUri(query), headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);
        List<MSubCategory> subList = [];
        for (dynamic item in List.from(result['data'])) {
          subList.add(MSubCategory.fromMap(item));
        }

        print('subList $subList');
        $subCategory.sink$(subList);

        completer.complete(
            RestfulResult(statusCode: STATUS.SUCCESS_CODE, message: 'ok'));
      },
    ).catchError((error) {
      // GHelperNavigator.pushLogin();
    });

    return completer.future;
  }

  Future<RestfulResult> post({
    required String name,
    BuildContext? context,
    String parent = '',
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String _encodeData = jsonEncode({
      "name": name,
      "parent": parent,
    });

    http
        .post(getRequestUri(PATH.CATEGORY),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);

      if (name == '') {
        return completer.complete(RestfulResult.fromMap(
          result,
          response.statusCode,
        ));
      }

      return completer.complete(RestfulResult.fromMap(
        result,
        response.statusCode,
      ));
    }).catchError((error) {
      print(error);
    });

    return completer.future;
  }

  Future<RestfulResult> delete({
    required String id,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    String _encodeData = jsonEncode({
      "id": id,
    });

    http
        .delete(getRequestUri(PATH.CATEGORY),
            body: _encodeData, headers: _headers)
        .then((response) {
      Map result = json.decode(response.body);
      return completer.complete(
        RestfulResult.fromMap(
          result,
          response.statusCode,
        ),
      );
    });

    return completer.future;
  }
}
