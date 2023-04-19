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
                    buildTextField(
                      ctr: ctrID,
                      label: 'id',
                      hint: 'id',
                    ),
                    buildTextField(
                      ctr: ctrPW,
                      label: 'pw',
                      hint: 'pw',
                      obscureText: true,
                    ),
                    buildElevatedButton(
                      width: double.infinity,
                      child: TAutoSizeText('login'),
                      onPressed: () async {
                        //
                        RestfulResult result = await GServiceLogin.post(
                          ctrID.text,
                          ctrPW.text,
                        );

                        if (result.isSuccess) {
                          return GHelperNavigator.pushHome();
                        }

                        return buildErrorDialog(
                          result.message,
                          result.statusCode,
                          context,
                        );
                      },
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
