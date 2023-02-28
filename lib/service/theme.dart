part of 'lib.dart';

class ServiceTheme {
  static ServiceTheme? _instance;
  factory ServiceTheme.getInstance() => _instance ??= ServiceTheme._internal();

  ServiceTheme._internal();

  late final TStream<ThemeData> $theme = TStream<ThemeData>();
  ThemeData get theme => $theme.lastValue;

  late final Box<int> _box;

  StreamSubscription<BoxEvent>? _subBox;

  Future<void> fetch() async {
    if (!Hive.isBoxOpen('theme')) {
      _box = await Hive.openBox('theme');
    }

    // TODO : 최초 실행시에만 추가
    if (_box.values.isEmpty) {
      _box.put('theme', 0);
    }

    // init : 최초 _subBox가 null이면 $theme에 sink$
    if (_subBox == null) {
      int index = _box.values.first;
      $theme.sink$(THEME.THEMEDATA_LIST[index]);
    }

    // _subBox가 생성된 후 _box에 subscription을 달아 갱신이 될때마다
    // $theme에 sink$ 하도록 작성
    _subBox = _box.watch().listen((event) {
      int index = event.value;
      $theme.sink$(THEME.THEMEDATA_LIST[index]);
    });
  }

  void update(THEME.Type type) {
    int index = THEME.TYPE_LIST.indexOf(type);
    _box.put('theme', index);
  }
}
