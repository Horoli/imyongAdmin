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
          builder: (BuildContext context, MSubCategory value) {
            print(value);
            print(value.subCategory);
            return ListView.builder(
              itemCount: value.subCategory.length,
              itemBuilder: (context, index) => Text(value.subCategory[index]),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceSubCategory.get();
  }
}
