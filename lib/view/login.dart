part of '/common.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({Key? key}) : super(key: key);

  @override
  _ViewLoginState createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  TextEditingController ctrID = TextEditingController(text: 'horoli');
  TextEditingController ctrPW = TextEditingController(text: '1234');
  //
  @override
  Widget build(BuildContext context) {
    bool isPort = MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return Center(
          child: SizedBox(
            width: isPort ? width * 0.95 : width * 0.15,
            height: isPort ? height * 0.5 : height * 0.18,
            child: Card(
              child: Row(
                children: [
                  Column(
                    children: [
                      buildTextField(ctrID).expand(),
                      buildTextField(ctrPW).expand(),
                    ],
                  ).expand(),
                  ElevatedButton(
                    child: Container(),
                    onPressed: () {
                      GServiceLogin.post(id: ctrID.text, pw: ctrPW.text)
                          .then((value) => GHelperNavigator.pushHome());
                    },
                  ).expand(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(TextEditingController ctr) {
    return TextFormField(
      controller: ctr,
      expands: true,
      maxLines: null,
      maxLength: null,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 40),
      ),
    );
  }

  void buildDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // CircularProgressIndicator(strokeWidth: 10),
                Center(child: Text('invalid password'))
              ],
            ),
          ),
        );
      },
    );

    GServiceLogin.post(id: ctrID.text, pw: ctrPW.text);

    //   if (hiveMLogin.isEmpty) {
    //     print('isEmpty');
    //     GServiceLogin.post(id: ctrID.text, pw: ctrPW.text);
    //     hiveTheme.put('theme', 'light');
    //   }

    //   if (hiveMLogin.isNotEmpty) {
    //     print('isNotEmpty');
    //     // TODO : TEST THEME CODE, MUST DELETE
    //     if (hiveTheme.values.isEmpty ||
    //         hiveTheme.values.first.toString() == 'light') {
    //       hiveTheme.put('theme', 'light');
    //       GServiceTheme.$theme.sink$(GServiceTheme.light());
    //     }

    //     // TODO : TEST THEME CODE, MUST DELETE
    //     if (hiveTheme.values.first.toString() == 'dark') {
    //       GServiceTheme.$theme.sink$(GServiceTheme.dark());
    //     }
    //     GHelperNavigator.pushHome();
    //   }
  }

  @override
  void initState() {
    super.initState();
  }
}
