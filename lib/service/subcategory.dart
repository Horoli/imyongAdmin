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

  TStream<MSubCategory> $selectedSubCategory = TStream<MSubCategory>()
    ..sink$(emptySubCategory);
  TStream<MSubCategory> $selectedSubInSubCategory = TStream<MSubCategory>()
    ..sink$(emptySubCategory);

  // TODO : DEV CODE // subCategories의 전체 데이터를
  // 한번 가져와야 데이터를 활용할 수 있음. 가져 온뒤 별도의 stream에 저장
  Future<RestfulResult> getAll() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    Map<String, String> queryParameters = {'map': 'map'};

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.SUBCATEGORY, queryParameters)
        : Uri.https(PATH.FORIEGN_URL, PATH.SUBCATEGORY, queryParameters);

    http.get(query, headers: _headers).then((value) {
      Map result = json.decode(value.body);
      print('sub $result');
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

  // TODO : id가 일치하는 subcategory를 가져오는 함수
  Future<RestfulResult> getById({required String id}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    if (id == '') {
      completer.complete(
        RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: 'error: id is empty',
        ),
      );

      return completer.future;
    }
    Map<String, String> queryParameters = {'id': id};

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.CATEGORY, queryParameters)
        : Uri.https(PATH.FORIEGN_URL, PATH.CATEGORY, queryParameters);

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    http.get(query, headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);
        print('result $result');

        MSubCategory getSubCategory = MSubCategory.fromMap(result['data']);
        print('getSubCategory $getSubCategory');

        completer.complete(RestfulResult(
          statusCode: STATUS.SUCCESS_CODE,
          message: 'ok',
          data: getSubCategory,
        ));
      },
    ).catchError((error) {
      print('subCategory getbyId error $error');
      // GHelperNavigator.pushLogin();
    });

    return completer.future;
  }

  Future<RestfulResult> getByParent(
      {String parent = '', bool isNoChildren = false}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();
    selectedCategoriesId = [];

    if (parent == '') {
      completer.complete(
        RestfulResult(
          statusCode: STATUS.UNKNOWN_CODE,
          message: 'error: parent is empty',
        ),
      );

      return completer.future;
    }

    Map<String, String> queryParameters = {'parent': parent};

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.CATEGORY, queryParameters)
        : Uri.https(PATH.FORIEGN_URL, PATH.CATEGORY, queryParameters);

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    http.get(query, headers: _headers).then(
      (response) {
        Map result = json.decode(response.body);
        print('result $result');
        List<MSubCategory> subList = [];
        for (dynamic item in List.from(result['data'])) {
          subList.add(MSubCategory.fromMap(item));
        }

        print('subList $subList');

        $subCategory.sink$(subList);

        completer.complete(RestfulResult(
          statusCode: STATUS.SUCCESS_CODE,
          message: 'ok',
          data: subList,
        ));
      },
    ).catchError((error) {
      print('subcategory getByParent error $error');
      // GHelperNavigator.pushLogin();
    });

    return completer.future;
  }

  //
  Future<RestfulResult> post({
    required String name,
    String parent = '',
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    final Map<String, String> _headers = createHeaders(
      tokenKey: HEADER.TOKEN,
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    String _encodeData = jsonEncode({
      "name": name,
      "parent": parent,
    });

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.CATEGORY)
        : Uri.https(PATH.FORIEGN_URL, PATH.CATEGORY);

    http.post(query, body: _encodeData, headers: _headers).then((response) {
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
      tokenValue: GSharedPreferences.getString(HEADER.LOCAL_TOKEN),
    );

    String _encodeData = jsonEncode({
      "id": id,
    });

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.CATEGORY)
        : Uri.https(PATH.FORIEGN_URL, PATH.CATEGORY);

    http.delete(query, body: _encodeData, headers: _headers).then((response) {
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
