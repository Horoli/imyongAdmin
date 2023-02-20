part of '/common.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({Key? key}) : super(key: key);

  @override
  _ViewLoginState createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  TextEditingController ctrID = TextEditingController(text: 'horoli');
  TextEditingController ctrPW = TextEditingController(text: '123');
  //
  @override
  Widget build(BuildContext context) {
    bool isPort = MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        print(width * 0.4);
        print(height * 0.4);

        return Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 270,
              // width: isPort ? width * 0.5 : width * 0.4,
              // height: isPort ? height * 0.4 : height * 0.4,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextField(ctrID, label: 'id', hint: 'id'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextField(
                        ctrPW,
                        label: 'pw',
                        hint: 'pw',
                        obscureText: true,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: TAutoSizeText('login'),
                        onPressed: () async {
                          //
                          RestfulResult result = await GServiceLogin.post(
                            ctrID.text,
                            ctrPW.text,
                          );

                          print('result $result');
                          // print(result.data);

                          if (result.isSuccess) {
                            return GHelperNavigator.pushHome();
                          }

                          return buildDialog(result.message, result.statusCode);
                        },
                      ),
                    ).expand(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(
    TextEditingController ctr, {
    bool obscureText = false,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: ctr,
      // expands: true,
      // maxLines: null,
      // maxLength: null,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 40),
        labelText: label,
        hintText: hint,
      ),
    );
  }

  void buildDialog(String message, int statusCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  Center(child: Text('$statusCode')).expand(),
                  Center(child: Text(message)).expand(),
                ],
              )
              // child: Stack(
              //   fit: StackFit.expand,
              //   children: [
              //     // CircularProgressIndicator(strokeWidth: 10),
              //     Center(child: Text('$statusCode')),
              //     Center(child: Text(message))
              //   ],
              // ),
              ),
        );
      },
    );

    // GServiceLogin.post(id: ctrID.text, pw: ctrPW.text);

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
