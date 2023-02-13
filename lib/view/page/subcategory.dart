part of '/common.dart';

class ViewSubCategory extends StatefulWidget {
  const ViewSubCategory({Key? key}) : super(key: key);

  @override
  _ViewSubCategoryState createState() => _ViewSubCategoryState();
}

class _ViewSubCategoryState extends State<ViewSubCategory> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Container(
        color: Colors.blue,
        child: TStreamBuilder(
          stream: GServiceSubCategory.$subCategory.browse$,
          builder: (BuildContext context, Map<String, MSubCategory> value) {
            print(value);
            return ListView.builder(
              itemCount: value.keys.length,
              itemBuilder: (context, index) => const Text(''),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print(GServiceMainCategory.getMainCategory);

    GServiceSubCategory.post(
      id: newUUID(),
      maincategory: GServiceMainCategory.getMainCategory.keys.first,
      subcategory: "asd",
    );
  }
}
