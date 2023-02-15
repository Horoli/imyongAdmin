import 'package:flutter/material.dart';
import 'package:imyong/common.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'preset/router.dart' as ROUTER;
import 'preset/color.dart' as COLOR;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initHive();
  registerHiveAdapter();

  _initService();
  _getData();
  runApp(AppRoot());
}

void _initService() {
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
}

void registerHiveAdapter() {
  Hive.registerAdapter<MLogin>(MLoginAdapter());
}

class AppRoot extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes = {
    ROUTER.LOGIN: (BuildContext context) => ViewLogin(),
    ROUTER.HOME: (BuildContext context) => ViewHome(),
  };

  @override
  Widget build(BuildContext context) {
    //
    return MaterialApp(
      // theme: ThemeData.dark(),
      title: 'imyong',
      initialRoute: ROUTER.LOGIN,
      routes: routes,
    );
  }
}
