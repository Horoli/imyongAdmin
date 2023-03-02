part of 'lib.dart';

class ServiceSubCategory {
  static ServiceSubCategory? _instance;
  factory ServiceSubCategory.getInstance() =>
      _instance ??= ServiceSubCategory._internal();

  ServiceSubCategory._internal();

  final TStream<List<MSubCategory>> $subCategory =
      TStream<List<MSubCategory>>();
  List<MSubCategory> get subCategory => $subCategory.lastValue;

  final TStream<Map<String, MSubCategory>> $allSubCategory =
      TStream<Map<String, MSubCategory>>();
  Map<String, MSubCategory> get allSubCategory => $allSubCategory.lastValue;

  List<String> selectedCategoriesId = [];

  // TODO : DEV CODE // subCategories의 전체 데이터를
  // 한번 가져와야 데이터를 활용할 수 있음. 가져 온뒤 별도의 stream에 저장
  Future<RestfulResult> getAll() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: hiveMLogin.values.first.token,
    );

    http
        .get(getRequestUri('subcategory?map=map'), headers: _headers)
        .then((value) {
      Map result = json.decode(value.body);
      Map<String, MSubCategory> convertResult = {};
      for (dynamic item in result['data'].keys) {
        String convertItem = item.toString();
        MSubCategory convertCategory =
            MSubCategory.fromMap(result['data'][item]);
        convertResult[convertItem] = convertCategory;
      }
      $allSubCategory.sink$(convertResult);

      completer.complete(
          RestfulResult(statusCode: STATUS.SUCCESS_CODE, message: 'ok'));
    }).catchError((error) {
      print('getAll error ${error}');
    });
    return completer.future;
  }

  Future<RestfulResult> get({String parent = '', bool isNoChildren = false}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();
    selectedCategoriesId = [];

    // parent가 빈값이면 /subcategory(url),
    // parent에 입력 값이 있으면 /category?id=$parent(query)
    String query =
        parent == '' ? PATH.SUBCATEGORY : '${PATH.CATEGORY_QUERY}$parent';
    if (isNoChildren) {
      query = 'nochildrencategory';
    }

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
      print('error $error');
      // GHelperNavigator.pushLogin();
    });

    return completer.future;
  }

  //
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

      // name이 입력되지 않았으면 error return
      if (name == '') {
        print('statusCode : ${response.statusCode}');
        return completer.complete(RestfulResult.fromMap(
          result,
          response.statusCode,
        ));
      }

      return completer.complete(RestfulResult.fromMap(
        result,
        response.statusCode,
      ));
    }).catchError((error) {});

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
