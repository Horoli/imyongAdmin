part of '/common.dart';

class ViewMainCategory extends StatefulWidget {
  const ViewMainCategory({Key? key}) : super(key: key);

  @override
  _VieMainCategoryState createState() => _VieMainCategoryState();
}

class _VieMainCategoryState extends State<ViewMainCategory> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
        child: Row(
      children: [
        asd().expand(),
        Container(color: Colors.blue).expand(),
      ],
    ));
  }

  Widget asd() {
    return ListView(
      children: List.generate(
        50,
        (int index) => Container(
          height: 50,
          color: index % 2 == 0 ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
