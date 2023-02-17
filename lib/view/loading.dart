// part of '/common.dart';

// class ViewLoading extends StatefulWidget {
//   const ViewLoading({Key? key}) : super(key: key);

//   @override
//   _ViewLoadingState createState() => _ViewLoadingState();
// }

// class _ViewLoadingState extends State<ViewLoading> {
//   //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 500,
//           height: 500,
//           child: Stack(
//             fit: StackFit.expand,
//             children: const [
//               CircularProgressIndicator(strokeWidth: 10),
//               Center(child: Text('Loading')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initHive();
//     _registerHiveAdapter();
//     Future(GHelperNavigator.pushLogin);
//   }

//   Future<void> _initHive() async {
//     await Hive.initFlutter();
//     hiveMLogin = await Hive.openBox('login');
//     hiveTheme = await Hive.openBox('theme');
//   }

//   Future<void> _registerHiveAdapter() async {
//     Hive.registerAdapter<MLogin>(MLoginAdapter());
//   }
// }
