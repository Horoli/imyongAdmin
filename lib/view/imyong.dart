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
    return ElevatedButton(
      child: const Text('asd'),
      onPressed: () {
        GServiceType.getType();
      },
    );
  }
}
