part of '/common.dart';

class ViewConvertText extends StatefulWidget {
  const ViewConvertText({Key? key}) : super(key: key);

  @override
  _ViewConvertTextState createState() => _ViewConvertTextState();
}

class _ViewConvertTextState extends State<ViewConvertText> {
  //
  final String pattern =
      '\\d*\\n\\d{2}:\\d{2}:\\d{2},\\d{3} --> \\d{2}:\\d{2}:\\d{2},\\d{3}\\n';

  //
  late double maxWidth = MediaQuery.of(context).size.width;
  late double maxheight = MediaQuery.of(context).size.height;
  //
  late final TextEditingController ctrText = TextEditingController(text: '');
  late final TextEditingController ctrPattern =
      TextEditingController(text: pattern);
  //
  TStream<bool> $fieldFixed = TStream<bool>()..sink$(true);
  TStream<String> $text = TStream<String>()..sink$('');
  //
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxWidth * 0.95,
        height: maxheight * 0.8,
        child: Column(
          children: [
            //
            Row(
              children: [
                buildInputPattern().expand(),
                buildFixedFlagButton(),
              ],
            ).expand(),
            //
            Row(
              children: [
                buildTextFormField(controller: ctrText).expand(),
                const Icon(Icons.arrow_forward),
                buildResultText().expand(),
              ],
            ).expand(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildConvertButton(),
                buildCopyButton(),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      height: double.infinity,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildInputPattern() {
    return TStreamBuilder(
      stream: $fieldFixed.browse$,
      builder: (BuildContext context, bool isFixed) {
        return TextFormField(
          readOnly: isFixed,
          controller: ctrPattern,
        );
      },
    );
  }

  Widget buildFixedFlagButton() {
    return TStreamBuilder(
      stream: $fieldFixed.browse$,
      builder: (BuildContext context, bool isFixed) {
        String label = isFixed ? 'unfixing' : 'fixing';
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: COLOR.CHICK_YELLOW,
          ),
          child: Text(label, style: const TextStyle(color: COLOR.GREY)),
          onPressed: () {
            $fieldFixed.sink$(!isFixed);
          },
        );
      },
    );
  }

  Widget buildConvertButton() {
    String label = 'convert';

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: COLOR.CHICK_YELLOW,
      ),
      child: Text(label, style: const TextStyle(color: COLOR.GREY)),
      onPressed: () {
        if (ctrText.text.length < 5) {
          showSnackBar('5자 이상 입력하세요.');
          return;
        }
        if (ctrText.text.length >= 5) {
          String convert = convertText();
          $text.sink$(convert);
          return;
        }
      },
    );
  }

  Widget buildCopyButton() {
    String label = 'copy';
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: COLOR.CHICK_YELLOW,
      ),
      child: Text(label, style: const TextStyle(color: COLOR.GREY)),
      onPressed: () {
        if ($text.lastValue.length < 5) {
          showSnackBar('5자 이상 입력하세요.');
          return;
        }

        if ($text.lastValue.length >= 5) {
          Clipboard.setData(ClipboardData(text: $text.lastValue));
          showSnackBar('copy complete');
        }
      },
    );
  }

  Widget buildResultText() {
    print($text.lastValue);

    return TStreamBuilder(
      stream: $text.browse$,
      builder: (BuildContext context, String text) {
        return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
          ),
          child: SelectableText(
            text,
            showCursor: true,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String convertText() {
    RegExp expFirst = RegExp(ctrPattern.text);
    RegExp expZeroToNine = RegExp(r'[0-9]\.[0-9]');

    String convertText = ctrText.text.replaceAll(expFirst, '');

    String addString = '';

    List<String> splitText = convertText.split("\n");

    splitText.forEach((String text) {
      if (text.isNotEmpty) {
        //
        text = text.replaceAll(RegExp(r'\W{3}'), '···');

        text = text.replaceAll(RegExp(r'Dr\.'), 'Dr-');

        if (text.contains(expZeroToNine)) {
          // print(text);
          List<String> innerSplitList = text.split(' ');
          print('innerSplitList $innerSplitList');

          innerSplitList.forEach((String string) {
            RegExpMatch? regMatch = expZeroToNine.firstMatch(string);

            if (regMatch != null) {
              String regMatchInput = regMatch.input;
              print('regMatchInput $regMatchInput');
              String getRegMatchInput = regMatchInput.replaceFirst('.', '_');
              print('regInput $getRegMatchInput');
              text = text.replaceAll(regMatchInput, '${getRegMatchInput}');
            }
          });
        }

        text = text.replaceAll(RegExp(r'\W{3}Dr'), '[Dr');
        //
        addString =
            addString.isEmpty ? addString + text : addString + ' ' + text;
      }
    });

    addString = addString.replaceAll(RegExp('[...]'), '. \n \n');
    addString = addString.replaceAll(RegExp(r'Dr\-'), 'Dr.');
    addString = addString.replaceAll(RegExp('_'), '.');

    return addString;
  }

  void showSnackBar(String label) {
    SnackBar snackBar = SnackBar(
      content: Text(label),
      duration: const Duration(seconds: 3),
    );
    // return snackBar;

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
