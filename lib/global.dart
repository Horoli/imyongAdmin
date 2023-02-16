part of 'common.dart';

const String baseURL = 'http://localhost:3000';

Uri getRequestUri(String path) => Uri.parse(p.join(baseURL, path));

late ServiceTheme GServiceTheme;
late ServiceType GServiceType;
late ServiceLogin GServiceLogin;
late ServiceGuest GServiceGuest;
late ServiceMainCategory GServiceMainCategory;

// late ServiceSubCategory GServiceSubCategory;

late final Box<MLogin> hiveMLogin;
late final Box<String> hiveTheme;
