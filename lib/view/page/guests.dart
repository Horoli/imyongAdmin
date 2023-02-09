part of '/common.dart';

class ViewGuests extends StatefulWidget {
  const ViewGuests({Key? key}) : super(key: key);

  @override
  _ViewGuestsState createState() => _ViewGuestsState();
}

class _ViewGuestsState extends State<ViewGuests> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Container(
        color: Colors.blue,
        child: TStreamBuilder(
          stream: GServiceGuest.$guests.browse$,
          builder: (BuildContext context, MGuest value) {
            // print(value);
            return Container();
            // return ListView.builder(
            //   itemCount: value.subCategory.length,
            //   itemBuilder: (context, index) => Text(value.subCategory[index]),
            // );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceGuest.get();
  }
}
