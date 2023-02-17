part of '/common.dart';

class ViewSetting extends StatefulWidget {
  const ViewSetting({Key? key}) : super(key: key);

  @override
  _ViewSettingState createState() => _ViewSettingState();
}

class _ViewSettingState extends State<ViewSetting> {
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
            GServiceTheme.update(THEME.Type.light);
          },
        ).expand(),
        const Padding(padding: EdgeInsets.all(8)),
        ElevatedButton(
          child: Text('dark'),
          onPressed: () {
            GServiceTheme.update(THEME.Type.dark);
          },
        ).expand(),
      ],
    );
  }
}
