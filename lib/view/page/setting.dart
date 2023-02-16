part of '/common.dart';

class ViewSetting extends StatefulWidget {
  const ViewSetting({Key? key}) : super(key: key);

  @override
  _ViewSettingState createState() => _ViewSettingState();
}

class _ViewSettingState extends State<ViewSetting> {
  ThemeData get dark => GServiceTheme.dark();
  ThemeData get light => GServiceTheme.light();
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Column(
        children: [
          buildThemeChangeButtons().expand(),
          Row().expand(),
          Row().expand(),
        ],
      ),
    );
  }

  Widget buildThemeChangeButtons() {
    return Row(
      children: [
        Text('ThemeChange').expand(),
        ElevatedButton(
          child: Text('light'),
          onPressed: () {
            GServiceTheme.$theme.sink$(light);
            hiveTheme.put('theme', 'light');
            print(hiveTheme.toMap());
          },
        ).expand(),
        const Padding(padding: EdgeInsets.all(8)),
        ElevatedButton(
          child: Text('dark'),
          onPressed: () {
            GServiceTheme.$theme.sink$(dark);
            hiveTheme.put('theme', 'dark');
            print(hiveTheme.toMap());
          },
        ).expand(),
      ],
    );
  }
}
