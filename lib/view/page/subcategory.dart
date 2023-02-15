// part of '/common.dart';

// class ViewSubCategory extends StatefulWidget {
//   const ViewSubCategory({Key? key}) : super(key: key);

//   @override
//   _ViewSubCategoryState createState() => _ViewSubCategoryState();
// }

// class _ViewSubCategoryState extends State<ViewSubCategory> {
//   //
//   @override
//   Widget build(BuildContext context) {
//     //
//     return buildBorderContainer(
//       child: Container(
//         color: Colors.blue,
//         child: TStreamBuilder(
//           stream: GServiceSubCategory.$subCategory.browse$,
//           builder: (BuildContext context, Map<String, MSubCategory> item) {
//             print(item);

//             return ListView.builder(
//               itemCount: item.keys.length,
//               itemBuilder: (context, index) => Text(
//                 '${GServiceMainCategory.getMainCategory[item.values.toList()[index].mainCategory]}',
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     GServiceSubCategory.get();
//     // print(GServiceMainCategory.getMainCategory);

//     // GServiceSubCategory.post(
//     //   id: newUUID(),
//     //   maincategory: GServiceMainCategory.getMainCategory.keys.first,
//     //   subcategory: "asd",
//     // );
//   }
// }
