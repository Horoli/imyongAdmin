part of '/common.dart';

class ViewDashboard extends StatefulWidget {
  const ViewDashboard({super.key});

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
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
