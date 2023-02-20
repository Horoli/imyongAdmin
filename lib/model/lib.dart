library model;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:imyong/common.dart';
import 'package:tnd_core/tnd_core.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// preset
import 'package:imyong/preset/color.dart' as COLOR;
import 'package:imyong/preset/path.dart' as PATH;
import 'package:imyong/preset/hive_id.dart' as HIVE_ID;
import 'package:imyong/preset/router.dart' as ROUTER;
import 'package:imyong/preset/tab.dart' as TAB;

part 'common.dart';
part 'base.dart';
part 'login.dart';
part 'type.dart';
part 'maincategory.dart';
part 'subcategory.dart';
part 'restful_result.dart';
