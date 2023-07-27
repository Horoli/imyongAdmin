part of 'common.dart';

// TEST
String uid = newUUID();

final HelperNavigator GHelperNavigator = HelperNavigator.getInstance();
final GlobalKey<NavigatorState> GNavigatorKey = GlobalKey<NavigatorState>();

Uri getRequestUri(String path) => Uri.parse(p.join(URL, path));

Map<String, String> createHeaders({String? tokenKey, String? tokenValue}) {
  Map<String, String> headers = {
    HEADER.CONTENT_TYPE: HEADER.JSON,
  };
  if (tokenKey != null) {
    headers[tokenKey] = tokenValue!;
  }

  return headers;
}

// late final LocalStorage localStorage;
late final SharedPreferences GSharedPreferences;

final ServiceTheme GServiceTheme = ServiceTheme.getInstance();
late ServiceType GServiceType;
late ServiceLogin GServiceLogin;
late ServiceGuest GServiceGuest;
late ServiceMainCategory GServiceMainCategory;
late ServiceSubCategory GServiceSubCategory;
late ServiceQuestion GServiceQuestion;
late ServiceDifficulty GServiceDifficulty;

MSubCategory emptySubCategory = MSubCategory(
  id: '',
  createdAt: 0,
  updatedAt: 0,
  name: '',
  parent: '',
  children: [],
);
