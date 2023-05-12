library common;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:html';
import 'dart:math';

// packageImport
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imyong/preset/path.dart';
import 'package:path/path.dart' as p;
import 'package:tnd_core/tnd_core.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';
import 'package:file_picker/file_picker.dart';

// preset
import 'package:imyong/preset/color.dart' as COLOR;
import 'package:imyong/preset/path.dart' as PATH;
import 'package:imyong/preset/hive_id.dart' as HIVE_ID;
import 'package:imyong/preset/router.dart' as ROUTER;
import 'package:imyong/preset/tab.dart' as TAB;
import 'package:imyong/preset/theme.dart' as THEME;
import 'package:imyong/preset/header.dart' as HEADER;
import 'package:imyong/preset/status.dart' as STATUS;
import 'package:imyong/preset/label.dart' as LABEL;
import 'package:imyong/preset/text_field.dart' as TEXT_FIELD;

// import inner packages
import 'package:imyong/service/lib.dart';
import 'package:imyong/model/lib.dart';

// global
part 'global.dart';

// widgets
part 'widgets/common_widgets.dart';
part 'widgets/tile/categories_tile.dart';
part 'widgets/form_question_edit.dart';

part 'helper/navigator.dart';

// view
part 'view/login.dart';
part 'view/home.dart';
// part 'view/loading.dart';

// page
part 'view/page/dashboard.dart';
part 'view/page/question.dart';
part 'view/page/guest.dart';
part 'view/page/maincategory.dart';
// part 'view/page/subcategory.dart';
part 'view/page/category.dart';
part 'view/page/setting.dart';
