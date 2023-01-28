import 'package:flutter/material.dart';
import 'package:imyong/common.dart';

import 'preset/router.dart' as ROUTER;
import 'preset/color.dart' as COLOR;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initService();
  runApp(AppRoot());
}

void _initService() {
  GServiceType = ServiceType.getInstance();
  GServiceLogin = ServiceLogin.getInstance();
}

class AppRoot extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes = {
    ROUTER.HOME: (BuildContext context) => ViewHome(),
    // ROUTER.LOTTO: (BuildContext context) => ViewLotto(),
    // ROUTER.CONVERT: (BuildContext context) => ViewConvertText(),
  };

  @override
  Widget build(BuildContext context) {
    //
    return MaterialApp(
      title: 'imyong',
      initialRoute: ROUTER.HOME,
      routes: routes,
    );
  }
}
