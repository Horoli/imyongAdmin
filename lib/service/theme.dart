part of 'lib.dart';

class ServiceTheme {
  static ServiceTheme? _instance;
  factory ServiceTheme.getInstance() => _instance ??= ServiceTheme._internal();

  ServiceTheme._internal();

  late final TStream<ThemeData> $theme = TStream<ThemeData>()..sink$(light());

  ThemeData get theme => $theme.lastValue;

  void fetch(ThemeData inputTheme) {
    $theme.sink$(inputTheme);
  }

  ThemeData dark() {
    return ThemeData.dark().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
        ),
      ),
    );
  }

  ThemeData light() {
    return ThemeData.light().copyWith(
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ButtonStyle(
        //     backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
        //   ),
        // ),
        );
  }
}
