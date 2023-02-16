part of '/common.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({Key? key}) : super(key: key);

  @override
  _ViewLoginState createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        ElevatedButton(
          child: const Text('admin Login'),
          onPressed: () async {
            if (hiveMLogin.isEmpty) {
              GServiceLogin.post(id: 'horoli', pw: '1234');
            }

            if (hiveMLogin.isNotEmpty) {
              // TODO : TEST THEME CODE, MUST DELETE
              if (hiveTheme.values.toString() == 'light') {
                GServiceTheme.$theme.sink$(GServiceTheme.light());
              }

              // TODO : TEST THEME CODE, MUST DELETE
              if (hiveTheme.values.toString() == 'dark') {
                GServiceTheme.$theme.sink$(GServiceTheme.dark());
              }
              Navigator.pushNamed(
                context,
                ROUTER.HOME,
              );
            }
          },
        ).expand(),
      ],
    );
  }
}
