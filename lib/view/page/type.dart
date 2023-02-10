part of '/common.dart';

class ViewType extends StatefulWidget {
  const ViewType({Key? key}) : super(key: key);

  @override
  _ViewTypeState createState() => _ViewTypeState();
}

class _ViewTypeState extends State<ViewType> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          Container(color: Colors.blue).expand(),
          TStreamBuilder(
            stream: GServiceType.$type.browse$,
            builder: (BuildContext context, MType value) {
              print(value);
              print(value.type);
              return ListView.builder(
                itemCount: value.type.length,
                itemBuilder: (context, index) => Text(value.type[index]),
              );
            },
          ).expand()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceType.get();
  }
}
