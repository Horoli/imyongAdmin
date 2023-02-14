part of '/common.dart';

class ViewMainCategory extends StatefulWidget {
  const ViewMainCategory({Key? key}) : super(key: key);

  @override
  _VieMainCategoryState createState() => _VieMainCategoryState();
}

class _VieMainCategoryState extends State<ViewMainCategory> {
  final TextEditingController ctrType = TextEditingController();
  final TextEditingController ctrMainCategory = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          buildEditingFields().expand(),
          TStreamBuilder(
            stream: GServiceMainCategory.$mainCategory.browse$,
            builder: (
              BuildContext context,
              Map<String, MMainCategory> item,
            ) {
              return Container(
                color: Colors.blue,
                child: ListView.builder(
                  itemCount: item.keys.length,
                  itemBuilder: (context, index) => Text(
                    '${item.values.toList()[index].mainCategory}',
                  ),
                ),
              );
            },
          ).expand(),
          ElevatedButton(
            child: const Text('add'),
            onPressed: () {
              GServiceMainCategory.post(
                id: newUUID(),
                type: ctrType.text,
                maincategory: ctrMainCategory.text,
              );
            },
          ).expand(),
        ],
      ),
    );
  }

  Widget buildEditingFields() {
    return Column(
      children: [
        TextFormField(
          controller: ctrType,
          readOnly: true,
        ).expand(),
        TextFormField(
          controller: ctrMainCategory,
        ).expand(),
        ElevatedButton(
          onPressed: () async {
            buildTypeDialog();
          },
          child: Container(),
        ).expand(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceType.get();
  }

  Future<void> buildTypeDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: createList());
      },
    );
  }

  List<SimpleDialogOption> createList() {
    List<String> types = GServiceType.type.type;
    return List.generate(
      types.length,
      (index) => SimpleDialogOption(
        child: Text(types[index]),
        onPressed: () {
          print('types[index] ${types[index]}');
          ctrType.text = types[index];
        },
      ),
    );
  }
}
