import 'package:flutter/material.dart';
import 'package:imyong/common.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imyong/preset/theme.dart' as THEME;
import 'package:imyong/service/lib.dart';
import 'package:imyong/model/lib.dart';
import 'package:tnd_pkg_widget/preset/color.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';
import 'preset/router.dart' as ROUTER;
import 'preset/color.dart' as COLOR;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GServiceTheme.fetch();

  _initHive();
  _registerHiveAdapter();
  _initService();
  runApp(AppRoot());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  hiveMLogin = await Hive.openBox('login');
}

Future<void> _registerHiveAdapter() async {
  Hive.registerAdapter<MLogin>(MLoginAdapter());
}

void _initService() {
  GServiceType = ServiceType.getInstance();
  GServiceLogin = ServiceLogin.getInstance();
  GServiceGuest = ServiceGuest.getInstance();
  GServiceMainCategory = ServiceMainCategory.getInstance();
  GServiceSubCategory = ServiceSubCategory.getInstance();
  GServiceQuestion = ServiceQuestion.getInstance();
  GServiceDifficulty = ServiceDifficulty.getInstance();
}

class AppRoot extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes = {
    ROUTER.LOGIN: (BuildContext context) => ViewLogin(),
    // ROUTER.LOADING: (BuildContext context) => ViewLoading(),
    ROUTER.HOME: (BuildContext context) => ViewHome(),
  };

  @override
  Widget build(BuildContext context) {
    return TStreamBuilder(
      stream: GServiceTheme.$theme.browse$,
      builder: (context, ThemeData theme) {
        return MaterialApp(
          theme: theme,
          title: 'imyong',
          navigatorKey: GNavigatorKey,
          initialRoute: ROUTER.LOGIN,
          routes: routes,
        );
      },
    );
  }
}
