part of '/common.dart';

class ViewImyong extends StatefulWidget {
  const ViewImyong({Key? key}) : super(key: key);

  @override
  _ViewImyongState createState() => _ViewImyongState();
}

class _ViewImyongState extends State<ViewImyong> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        ElevatedButton(
          child: const Text('login post'),
          onPressed: () async {
            GServiceLogin.login(id: 'horoli', pw: '1234');
          },
        ).expand(),
        ElevatedButton(
          child: const Text('type post'),
          onPressed: () async {
            GServiceType.getType(inputType: "asd");
          },
        ).expand(),
      ],
    );
  }
}
