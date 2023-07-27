part of '/common.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({super.key});

  @override
  ViewQuestionState createState() => ViewQuestionState();
}

class ViewQuestionState extends State<ViewQuestion> {
  final TextEditingController ctrCategory = TextEditingController();
  final TextEditingController ctrQuestion = TextEditingController();
  final TextEditingController ctrAnswer = TextEditingController();
  final TextEditingController ctrInfo = TextEditingController();
  final TextEditingController ctrDescription = TextEditingController();
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
          Column(
            children: [
              buildInputFields().expand(flex: 5),
              buildCompleteFields().expand(),
            ],
          ).expand()
        ],
      ),
    );
  }

  Widget buildQuestions() {
    return Column(
      children: [
        const Text(LABEL.QUESTION_LIST),
        QuestionHeaderTile(),
        TStreamBuilder(
          stream: GServiceQuestion.$questions.browse$,
          builder: (context, List<MQuestion> questions) {
            return buildBorderContainer(
              child: ListView.builder(
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
                    info: questions[index].info,
                    description: questions[index].description,
                    edit: const Icon(Icons.edit),
                    onPressedAction: () {
                      buildEditQuestionDialog(questions[index]);
                    },
                  );
                },
              ),
            );
          },
        ).expand(),
        buildPaginationButtons()
        //
      ],
    );
  }

  Widget buildPaginationButtons() {
    return TStreamBuilder(
      stream: GServiceQuestion.$totalQuestionCount.browse$,
      builder: (context, int totalQuestionCount) {
        return TStreamBuilder(
          initialData: 1,
          stream: GServiceQuestion.$selectedPaginationPage.browse$,
          builder: (context, int selectedPage) {
            int showPaginationCount =
                GServiceQuestion.$showPaginationCount.lastValue;

            List<int> showPages = getPaginationButton(
              selectedPage,
              showPaginationCount,
              totalQuestionCount,
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: showPages
                  .map((page) => buildElevatedButton(
                        child: Text('$page'),
                        color:
                            selectedPage == page ? Colors.blue : Colors.black,
                        onPressed: () {
                          GServiceQuestion.$selectedPaginationPage.sink$(page);

                          GServiceQuestion.getPagination(
                            selectedpaginationPage: page,
                            showPaginationCount: showPaginationCount,
                          );
                        },
                      ))
                  .toList(),
            ).sizedBox(height: 100);
          },
        );
      },
    );
  }

  // 입력받은 page를 기준으로 -2 ~ +2의 페이지를 가져옴. 단, 1페이지와 마지막 페이지는 제외
  List<int> getPaginationButton(
    int selectedPage,
    int showPaginationCount,
    int totalQuestionCount,
  ) {
    int buttonCount = (totalQuestionCount / showPaginationCount).ceil();
    List<int> pages = [];

    // TODO : page를 선택할 때, 1페이지와 마지막 페이지를 제외하고 -2 ~ +2의 페이지를 선택할 수 있도록 함
    for (int i = selectedPage - 2; i <= selectedPage + 2; i++) {
      if (i > 0 && i <= buttonCount) {
        pages.add(i);
      }
    }

    return pages;
  }

  Widget buildInputFields() {
    //     const Text(LABEL.QUESTION_ADD),
    return Column(
      children: [
        WidgetCategoriesSelect().expand(),
        buildBorderContainer(
          child: Row(
            children: [
              Column(
                children: [
                  const Text(LABEL.QUESTION_INFO_INPUT),
                  buildTextField(
                    ctr: ctrQuestion,
                    label: TEXT_FIELD.ENTER_QUESTION,
                    maxLines: 5,
                  ),
                  buildTextField(
                    ctr: ctrAnswer,
                    label: TEXT_FIELD.ENTER_ANSWER,
                  ),
                  buildTextField(
                    label: '학자',
                    ctr: ctrInfo,
                  ),
                  buildTextField(
                    label: '비고',
                    ctr: ctrDescription,
                  ),
                ],
              ).expand(),
              //
              Column(
                children: [
                  // buildSelectCategory().expand(),
                  buildImageSelectFields().expand(),
                ],
              ).expand(),
            ],
          ),
        ).expand(),
      ],
    );
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //       ],
    //     ).expand(),
    //   ],
    // );
  }

  Widget buildImageSelectFields() {
    return Column(
      children: [
        Row(
          children: [
            buildElevatedButton(
              width: double.infinity,
              child: const Text(LABEL.SELECT_IMAGE),
              onPressed: () async {
                // TODO : image를 선택해서 선택한 이미지를 $base64Images에 sink
                await selectImageFile(multiSelect: true).then((v) {
                  $base64Images.sink$(v);
                });
              },
            ).expand(),
            buildElevatedButton(
              width: double.infinity,
              child: const Text(LABEL.CANCEL_IMAGE),
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
                  return buildBorderContainer(
                    child: Image.memory(
                      base64Decode(base64Images[index]),
                    ),
                  );
                },
              ),
            );
          },
        ).expand(flex: 10),
      ],
    );
  }

  Widget buildCompleteFields() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildElevatedButton(
            width: double.infinity,
            child: const Text(LABEL.SAVE),
            onPressed: () async {
              RestfulResult result = await GServiceQuestion.post(
                question: ctrQuestion.text,
                answer: ctrAnswer.text,
                categoryID: ctrCategory.text,
                images: $base64Images.lastValue,
                info: ctrInfo.text,
                description: ctrDescription.text,
              );
              // TODO : 서버 연결에 따른 예외처리
              if (!result.isSuccess) {
                showSnackBar(
                  msg: result.message,
                  context: context,
                );
                return;
              }

              GServiceQuestion.getPagination(
                showPaginationCount:
                    GServiceQuestion.$showPaginationCount.lastValue,
                selectedpaginationPage:
                    GServiceQuestion.$selectedPaginationPage.lastValue,
              );

              showSnackBar(
                msg: '저장되었습니다.',
                context: context,
              );
            },
          ).expand(),
          buildElevatedButton(
            color: Colors.black,
            width: double.infinity,
            child: const Text(LABEL.DELETE),
            onPressed: () async {},
          ).expand(),
        ],
      ),
    );
  }

  Widget buildSelectCategory({bool isEdit = false}) {
    return Column(
      children: [
        const Text(LABEL.SELECT_CATEGORY),
        TStreamBuilder(
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
        ).expand(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceSubCategory.get(isNoChildren: true);
    GServiceSubCategory.getAll();
    GServiceQuestion.getPagination(
      showPaginationCount: GServiceQuestion.$showPaginationCount.lastValue,
      selectedpaginationPage:
          GServiceQuestion.$selectedPaginationPage.lastValue,
    );
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
