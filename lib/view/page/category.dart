part of '/common.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({Key? key}) : super(key: key);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final TextEditingController ctrMainCategory = TextEditingController();
  final TextEditingController ctrSubCategory = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Column(
        children: [
          // TODO : main
          buildManagementMainCategory().expand(),
          // TODO : sub
          buildManagementSubCategory().expand(),
          // Container(color: Colors.blue[400]).expand(),

          Container(color: Colors.green[400]).expand(),
          ElevatedButton(
            child: Text('test'),
            onPressed: () {
              String parent = ctrSubCategory.text.isNotEmpty
                  ? ctrSubCategory.text
                  : ctrMainCategory.text;

              GServiceSubCategory.post(
                name: '귀납법',
                parent: parent,
              );
            },
          ).expand(),
        ],
      ),
    );
  }

  Widget buildManagementMainCategory() {
    return Row(
      children: [
        TextFormField(
          controller: ctrMainCategory,
          readOnly: true,
        ).expand(),
        ElevatedButton(
          onPressed: () async {
            buildCategoriesDialog(createMainCategories());
          },
          child: Text('main'),
        ).expand(),
        TStreamBuilder(
          stream: GServiceMainCategory.$mainCategory.browse$,
          builder: (BuildContext context, MainCategory category) {
            List<String> mainCategories =
                List<String>.from(category.map.values);

            return ListView.builder(
                itemCount: mainCategories.length,
                itemBuilder: (context, int index) {
                  return Text(mainCategories[index]);
                });
          },
        ).expand(),
      ],
    );
  }

  Widget buildManagementSubCategory() {
    return Row(
      children: [
        TextFormField(
          controller: ctrSubCategory,
          readOnly: true,
        ).expand(),
        ElevatedButton(
          child: Text('sub'),
          onPressed: () async {
            buildCategoriesDialog(createSubCategories());
          },
        ).expand(),
        TStreamBuilder(
          stream: GServiceSubCategory.$subCategory.browse$,
          builder: (BuildContext context, List<MSubCategory> subCategories) {
            return ListView.builder(
              itemCount: subCategories.length,
              itemBuilder: (context, int index) {
                print(subCategories[index].name);
                return Row(
                  children: [
                    Text(subCategories[index].id),
                    Text(subCategories[index].name),
                    // Text(subCategories[index].parent),
                    // Text('${subCategories[index].children}'),
                  ],
                );
              },
            );
          },
        ).expand(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceSubCategory.get(isSub: true);
  }

  Future<void> buildCategoriesDialog(List<Widget> categories) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: categories);
      },
    );
  }

  List<SimpleDialogOption> createMainCategories() {
    Map<String, String> mainCategories =
        Map<String, String>.from(GServiceMainCategory.mainCategory.map);
    print(mainCategories.length);
    return List.generate(
      mainCategories.length,
      (index) => SimpleDialogOption(
        child: Text(mainCategories.values.toList()[index]),
        onPressed: () {
          ctrMainCategory.text = mainCategories.keys.toList()[index];
          GServiceSubCategory.get(parent: ctrMainCategory.text);
          // GServiceSubCategory.get();
        },
      ),
    );
  }

  List<MSubCategory> get subCategories => GServiceSubCategory.subCategory;

  List<SimpleDialogOption> createSubCategories() {
    return List.generate(
      subCategories.length,
      (index) => SimpleDialogOption(
        child: Row(
          children: [
            Text(subCategories[index].id).expand(),
            Text(subCategories[index].name).expand(),
          ],
        ),
        onPressed: () {
          ctrSubCategory.text = subCategories[index].id;
          // setState(() {
          GServiceSubCategory.get(parent: ctrSubCategory.text);
          // });
        },
      ),
    );
  }
}
