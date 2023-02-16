import 'package:flutter/material.dart';
import 'package:imyong/common.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imyong/service/lib.dart';
import 'package:imyong/model/lib.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';
import 'preset/router.dart' as ROUTER;
import 'preset/color.dart' as COLOR;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initHive();
  _registerHiveAdapter();

  _initService();
  _getData();
  runApp(AppRoot());
}

void _initService() {
  GServiceTheme = ServiceTheme.getInstance();
  GServiceType = ServiceType.getInstance();
  GServiceLogin = ServiceLogin.getInstance();
  GServiceGuest = ServiceGuest.getInstance();
  GServiceMainCategory = ServiceMainCategory.getInstance();
  // GServiceSubCategory = ServiceSubCategory.getInstance();
}

void _getData() {
  GServiceMainCategory.get();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  hiveMLogin = await Hive.openBox('login');
  hiveTheme = await Hive.openBox('theme');
}

void _registerHiveAdapter() {
  Hive.registerAdapter<MLogin>(MLoginAdapter());
}

class AppRoot extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes = {
    ROUTER.LOGIN: (BuildContext context) => ViewLogin(),
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
          initialRoute: ROUTER.LOGIN,
          routes: routes,
        );
      },
    );
  }
}
