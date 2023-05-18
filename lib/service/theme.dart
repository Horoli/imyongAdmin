part of 'lib.dart';

class ServiceTheme {
  static ServiceTheme? _instance;
  factory ServiceTheme.getInstance() => _instance ??= ServiceTheme._internal();

  ServiceTheme._internal();

  late final TStream<ThemeData> $theme = TStream<ThemeData>();
  ThemeData get theme => $theme.lastValue;

  Future<void> fetch() async {
    bool storageIsOpen = GSharedPreferences.getInt('theme') != null;
    storageIsOpen ? _initStorage() : _setStorage();
  }

  void _setStorage() {
    int setTheme = 0;
    GSharedPreferences.setInt('theme', setTheme);
    $theme.sink$(THEME.THEMEDATA_LIST[setTheme]);
  }

  void _initStorage() {
    int setTheme = GSharedPreferences.getInt('theme')!;
    $theme.sink$(THEME.THEMEDATA_LIST[setTheme]);
  }

  void update(THEME.Type type) {
    int setTheme = THEME.TYPE_LIST.indexOf(type);
    GSharedPreferences.setInt('theme', setTheme);
    $theme.sink$(THEME.THEMEDATA_LIST[setTheme]);
  }
}
