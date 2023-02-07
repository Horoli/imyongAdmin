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
              GServiceLogin.login(id: 'horoli', pw: '1234');

              //
            }
            if (hiveMLogin.isNotEmpty) {
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
