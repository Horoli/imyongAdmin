part of '/common.dart';

class ViewDashboard extends StatefulWidget {
  const ViewDashboard({Key? key}) : super(key: key);

  @override
  _ViewDashboardState createState() => _ViewDashboardState();
}

class _ViewDashboardState extends State<ViewDashboard> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Container(
        color: Colors.blue,
        child: ElevatedButton(
          child: Text('a'),
          onPressed: () {
            GServiceGuest.getGuest(uuid: newUUID());
          },
        ),
      ),
    );
  }
}
