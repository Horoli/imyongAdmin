part of '/common.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({super.key});

  @override
  ViewQuestionState createState() => ViewQuestionState();
}

class ViewQuestionState extends State<ViewQuestion> {
  TextEditingController ctrCategory = TextEditingController();
  TextEditingController ctrQuestion = TextEditingController();
  TextEditingController ctrAnswer = TextEditingController();
  //
  List<MSubCategory> get filteredSubcategory => GServiceSubCategory.subCategory;
  Map<String, MSubCategory> get getAllCategory =>
      GServiceSubCategory.allSubCategory;

  final TStream<List<String>> $base64Images = TStream<List<String>>()
    ..sink$([]);
  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          buildQuestions().expand(),
          buildInputFields().expand(),
          buildCompleteFields().expand(),
        ],
      ),
    );
  }

  Widget buildQuestions() {
    return buildBorderContainer(
      child: Column(
        children: [
          const Text('question list'),
          TStreamBuilder(
              stream: GServiceQuestion.$questions.browse$,
              builder: (context, List<MQuestion> questions) {
                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    // TODO : categoryID를 이용해서 category를 가져옴
                    MSubCategory getSubCategory = GServiceSubCategory
                        .allSubCategory[questions[index].categoryID]!;

                    return QuestionTile(
                      mainCategory: getSubCategory.parent,
                      subCategory: getSubCategory.name,
                      question: questions[index].question,
                      answer: questions[index].answer,
                      edit: const Icon(Icons.edit),
                      onPressedAction: () {
                        buildEditQuestionDialog(questions[index]);
                        print(questions[index].id);
                      },
                    );
                  },
                );
              }).expand(),
        ],
      ),
    );
  }

  Widget buildInputFields() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildTextField(
            ctr: ctrQuestion,
            label: 'enter question',
            maxLines: 5,
          ),
          buildTextField(ctr: ctrAnswer, label: 'enter answer'),
          // buildTextField(label: 'enter score'),
          // buildElevatedButton(
          //   width: double.infinity,
          //   child: Text('select difficulty'),
          //   onPressed: () {
          //     buildCategoriesDialog(popDifficulty());
          //   },
          // ).expand(),
          const Text('selectCategory'),
          buildTextField(
            ctr: ctrCategory,
            label: 'selectedCategory ID',
            readOnly: true,
          ),
          buildCategories().expand(),
          buildImageSelectFields().expand(),
        ],
      ),
    );
  }

  Widget buildImageSelectFields() {
    return buildBorderContainer(
      child: Row(
        children: [
          Column(
            children: [
              buildElevatedButton(
                width: double.infinity,
                child: Text('이미지 선택'),
                onPressed: () async {
                  // TODO : image를 선택해서 선택한 이미지를 $base64Images에 sink
                  await selectImageFile(multiSelect: true).then((v) {
                    $base64Images.sink$(v);
                  });
                },
              ).expand(),
              buildElevatedButton(
                width: double.infinity,
                child: Text('이미지 선택 취소'),
                onPressed: () async {
                  $base64Images.sink$([]);
                },
              ).expand(),
            ],
          ).expand(),
          TStreamBuilder(
            stream: $base64Images.browse$,
            builder: (buildContext, List<String> base64Images) {
              // base64Images를 ListView로 이미지를 보여주는 widget
              return buildBorderContainer(
                child: ListView.builder(
                  itemCount: base64Images.length,
                  itemBuilder: (context, index) {
                    // print('base64Images $base64Images');
                    return Image.memory(base64Decode(base64Images[index]));
                  },
                ),
              );
            },
          ).expand(),
        ],
      ),
    );
  }

  Widget buildCompleteFields() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildElevatedButton(
            width: double.infinity,
            child: Text('저장'),
            onPressed: () async {
              RestfulResult result = await GServiceQuestion.post(
                question: ctrQuestion.text,
                answer: ctrAnswer.text,
                categoryID: ctrCategory.text,
                images: $base64Images.lastValue,
              );
              // TODO : 서버 연결에 따른 예외처리
              if (!result.isSuccess) {
                showSnackBar(
                  msg: result.message,
                  context: context,
                );
                return;
              }

              GServiceQuestion.get();

              showSnackBar(
                msg: '저장되었습니다.',
                context: context,
              );
            },
          ).expand(),
          buildElevatedButton(
            color: Colors.black,
            width: double.infinity,
            child: Text('삭제(미구현)'),
            onPressed: () async {},
          ).expand(),
        ],
      ),
    );
  }

  Widget buildCategories({bool isEdit = false}) {
    return TStreamBuilder(
      stream: GServiceSubCategory.$subCategory.browse$,
      builder: (BuildContext context, _) {
        return buildBorderContainer(
          child: ListView.builder(
            itemCount: filteredSubcategory.length,
            itemBuilder: (context, index) {
              return QuestionCategoryTile(
                selected: ctrCategory.text == filteredSubcategory[index].id,
                name: filteredSubcategory[index].name,
                onChanged: (bool? changed) {
                  setState(() {
                    if (!isEdit) {
                      changed!
                          ? ctrCategory.text = filteredSubcategory[index].id
                          : ctrCategory.text = '';
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceSubCategory.get(isNoChildren: true);
    GServiceSubCategory.getAll();
    GServiceQuestion.get();
    GServiceDifficulty.get();
  }

  Future<void> buildCategoriesDialog(List<Widget> options) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: options);
      },
    );
  }

  List<SimpleDialogOption> popDifficulty() {
    List<String> difficulty =
        List<String>.from(GServiceDifficulty.difficulty.map.values);
    return List.generate(
      difficulty.length,
      (int index) {
        return SimpleDialogOption(
          child: Row(
            children: [
              Text(difficulty[index]),
            ],
          ),
          onPressed: () {
            // ctrCategory.text = filteredSubcategory[index].id;
          },
        );
      },
    );
  }

  // TODO : listView에 포함된 question을 edit하는 pop
  Future<void> buildEditQuestionDialog(MQuestion selectedQuestion) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: GestureDetector(
                  onTap: () {},

                  child: AlertDialog(
                    content: FormQuestionEdit(
                      selectedQuestion: selectedQuestion,
                    ),
                  ),
                  // child: AlertDialog(
                  //   contentPadding: EdgeInsets.zero,
                  //   content: SizedBox(
                  //     width: width * 0.9,
                  //     height: height * 0.6,
                  //     child: Column(
                  //       children: [
                  //         Text(question.answer).expand(),
                  //         buildImageList(question.imageIDs).expand(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
