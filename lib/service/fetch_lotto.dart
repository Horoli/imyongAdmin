part of '/common.dart';

Future<LottoInfo> fetchLotto() async {
  String url =
      "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1024";
  // 'https://cors-anywhere.herokuapp.com/https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=931';

  Uri uri = Uri.parse(url);
  // print('uri $uri');
  print('step 1');
  final response = await http.get(Uri.parse(url));
  // http.Response response = await http.get(uri);
  // print('response $response');
  // print('response ${response.body.characters}');
  print('step 2');

  if (response.statusCode == 200) {
    //
    // print('asdasdasd');
    LottoInfo asd = LottoInfo.fromJson(jsonDecode(response.body));
    print(asd.drwNoDate);

    return LottoInfo.fromJson(jsonDecode(response.body));
  } else {
    //
    throw Exception('failed to load Data');
  }
}
