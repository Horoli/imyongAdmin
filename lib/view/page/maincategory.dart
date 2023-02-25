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
          // TStreamBuilder(
          //   stream: GServiceMainCategory.$mainCategory.browse$,
          //   builder: (BuildContext context, MainCategory category) {
          //     List<String> mainCategories =
          //         List<String>.from(category.map.values);

          //     return ListView.builder(
          //         itemCount: mainCategories.length,
          //         itemBuilder: (context, int index) {
          //           return Text(mainCategories[index]);
          //         });
          //   },
          // ).expand(),

          // buildEditingFields().expand(),
          // buildStreamList().expand(),
          // ElevatedButton(
          //   child: const Text('add'),
          //   onPressed: () {
          //     if (ctrType.text != "") {
          //       // GServiceMainCategory.post(
          //       //   id: newUUID(),
          //       //   type: ctrType.text,
          //       //   maincategory: ctrMainCategory.text,
          //       // );
          //     }
          //   },
          // ).expand(),
          // ElevatedButton(
          //   child: const Text('del'),
          //   onPressed: () {
          //     if (ctrType.text != "") {
          //       // GServiceMainCategory.post(
          //       //   id: newUUID(),
          //       //   type: ctrType.text,
          //       //   maincategory: ctrMainCategory.text,
          //       //   isDelete: true,
          //       // );
          //     }
          //   },
          // ).expand(),
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

  Widget buildStreamList() {
    return TStreamBuilder(
      stream: GServiceMainCategory.$mainCategory.browse$,
      builder: (BuildContext context, Map<String, MMainCategory> item) {
        List<MMainCategory> mainCATs = item.values.toList();
        // TODO : type을 선택한 경우, filteredMAinCATs를 생성한 뒤 ListView를 그림
        if (ctrType.text != "") {
          List<MMainCategory> filteredMainCATs = [];
          for (MMainCategory cat in mainCATs) {
            if (cat.type == ctrType.text) {
              filteredMainCATs.add(cat);
            }
          }
          return buildListView(filteredMainCATs);
        }

        // TODO : type을 선택하지 않은 경우 모든 CATs를 return
        return buildListView(mainCATs);
      },
    );
  }

  Widget buildListView(List<MMainCategory> items) {
    return Container(
      color: Colors.blue,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          MMainCategory mainCAT = items[index];
          return Row(
            children: [
              Text('${mainCAT.type}').expand(),
              Text('${mainCAT.mainCategory}').expand(),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    // GServiceType.get(isCategoryView: true);
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
          setState(() {
            ctrType.text = types[index];
          });
        },
      ),
    );
  }
}
