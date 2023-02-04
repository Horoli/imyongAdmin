library common;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

// packageImport
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// preset
import 'package:imyong/preset/color.dart' as COLOR;
import 'package:imyong/preset/url.dart' as URL;
import 'package:imyong/preset/hive_id.dart' as HIVE_ID;

import 'package:tnd_core/tnd_core.dart';
import 'package:tnd_pkg_widget/extension.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';

//

// service
part 'service/fetch_lotto.dart';
part 'service/type.dart';
part 'service/login.dart';

// model
part 'model/lotto.dart';
part 'model/lotto_info.dart';

part 'model/type.dart';
part 'model/login.dart';

// part
part 'view/home.dart';
part 'view/lotto.dart';
part 'view/imyong.dart';
part 'global.dart';

// part 'extension.dart';
