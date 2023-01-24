import 'package:flutter/material.dart';
import 'package:olio/common.dart';

import 'common.dart';
import 'preset/router.dart' as ROUTER;
import 'preset/color.dart' as COLOR;

void main() {
  runApp(AppRoot());
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
      title: 'olio',
      initialRoute: ROUTER.HOME,
      routes: routes,
    );
  }
}
