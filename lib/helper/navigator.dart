part of '/common.dart';

class HelperNavigator {
  static HelperNavigator? _instance;
  factory HelperNavigator.getInstance() =>
      _instance ??= HelperNavigator._internal();

  HelperNavigator._internal();

  BuildContext get context => GNavigatorKey.currentContext!;

  void pushLogin() {
    //
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: ROUTER.LOGIN),
        builder: (BuildContext context) => ViewLogin(),
      ),
    );
  }

  void pushHome() {
    //
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: ROUTER.HOME),
        builder: (BuildContext context) => ViewHome(),
      ),
    );
  }
}
