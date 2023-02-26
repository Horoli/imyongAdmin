part of 'lib.dart';

class ServiceTheme {
  static ServiceTheme? _instance;
  factory ServiceTheme.getInstance() => _instance ??= ServiceTheme._internal();

  ServiceTheme._internal();

  late final TStream<ThemeData> $theme = TStream<ThemeData>()
    ..sink$(THEME.DARK);

  ThemeData get theme => $theme.lastValue;

  late final Box<int> _box;

  StreamSubscription<BoxEvent>? _subBox;

  Future<void> fetch() async {
    if (!Hive.isBoxOpen('theme')) {
      _box = await Hive.openBox('theme');
    }

    // $theme.sink$(THEME.THEMEDATA_LIST[int.parse(_box.values.toString())]);

    print('fetch fetch fetch fetch ');
    print(_box.toMap());

    print('_subBox1 $_subBox');

    _subBox ??= _box.watch().listen((event) {
      int index = event.value;
      print('index $index');
      print(THEME.THEMEDATA_LIST[index]);
    });

    print('_subBox2 ${_subBox}');
    // _box.watch().listen((event) {
    //   int index = event.value;
    //   $theme.sink$(THEME.THEMEDATA_LIST[index]);
    // });
  }

  void update(THEME.Type type) {
    int index = THEME.TYPE_LIST.indexOf(type);
    print('index $index');
    _box.put('theme', index);
  }
}
