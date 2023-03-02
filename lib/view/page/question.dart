part of '/common.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({Key? key}) : super(key: key);

  @override
  _ViewQuestionState createState() => _ViewQuestionState();
}

class _ViewQuestionState extends State<ViewQuestion> {
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: buildElevatedButton(
        child: Text('a'),
        onPressed: () {
          GServiceQuestion.post();
        },
      ),
    );
  }
}
