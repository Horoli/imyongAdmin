part of '/common.dart';

Widget buildBorderContainer({Widget? child}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    ),
  );
}
