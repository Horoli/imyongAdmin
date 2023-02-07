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
    return buildBorderContainer(child: Container(color: Colors.blue));
  }
}
