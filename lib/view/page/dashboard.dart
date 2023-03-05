part of '/common.dart';

class ViewDashboard extends StatefulWidget {
  const ViewDashboard({Key? key}) : super(key: key);

  @override
  _ViewDashboardState createState() => _ViewDashboardState();
}

class _ViewDashboardState extends State<ViewDashboard> {
  int first = 0;
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
            // print(GServiceGuest.testToken);
            print(uid);
            if (first == 0) {
              GServiceGuest.post(uuid: uid);
              first++;
            }
            GServiceGuest.get(GServiceGuest.testToken);

            // GServiceMainCategory.get();
            // GServiceSubCategory.get(parent: 'ab3aa1612dbd438a8288ca18d0bff3ee');
            // GServiceSubCategory.get(parent: 'en');
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceGuest.post(uuid: uid);
  }
}
