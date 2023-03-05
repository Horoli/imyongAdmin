part of '/common.dart';

class ViewGuest extends StatefulWidget {
  const ViewGuest({Key? key}) : super(key: key);

  @override
  _ViewGuestState createState() => _ViewGuestState();
}

class _ViewGuestState extends State<ViewGuest> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          Container(color: Colors.blue).expand(),
          // TStreamBuilder(
          //   stream: GServiceGuest.$guest.browse$,
          //   builder: (BuildContext context, Map<String, MGuest> item) {
          //     return ListView.builder(
          //       itemCount: item.keys.length,
          //       itemBuilder: (context, index) =>
          //           Text(item.keys.toList()[index]),
          //     );
          //   },
          // ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // GServiceGuest.get();
  }
}
