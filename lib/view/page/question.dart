part of '/common.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({super.key});

  @override
  ViewQuestionState createState() => ViewQuestionState();
}

class ViewQuestionState extends State<ViewQuestion> {
  TextEditingController ctrCategory = TextEditingController();

  //
  List<MSubCategory> get filteredSubcategory => GServiceSubCategory.subCategory;
  Map<String, MSubCategory> get getAllCategory =>
      GServiceSubCategory.allSubCategory;

  final TStream<List<String>> $base64Images = TStream<List<String>>();
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
                    return QuestionTile(
                      question: questions[index].question,
                      answer: questions[index].answer,
                      category: questions[index].categoryID,
                      edit: const Icon(Icons.abc),
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
          buildTextField(label: 'enter question'),
          buildTextField(label: 'enter answer'),
          buildTextField(label: 'enter score'),
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
          buildElevatedButton(
            child: Text('image Select'),
            onPressed: () async {
              // TODO : image를 선택해서 선택한 이미지를 $base64Images에 sink
              await selectImageFile(multiSelect: true).then((v) {
                $base64Images.sink$(v);
              });
            },
          ).expand(),
          TStreamBuilder(
            stream: $base64Images.browse$,
            builder: (buildContext, List<String> base64Images) {
              // base64Images를 ListView로 이미지를 보여주는 widget
              return buildBorderContainer(
                child: ListView.builder(
                  itemCount: base64Images.length,
                  itemBuilder: (context, index) {
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
            child: Text('post'),
            onPressed: () async {
              GServiceQuestion.post(
                categoryID: ctrCategory.text,
                images: $base64Images.lastValue,
              );
            },
          ).expand(),
          buildElevatedButton(
            child: Text('delete'),
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
    print('difficulty $difficulty');
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
        return AlertDialog(
          content: FormQuestionEdit(
            selectedQuestion: selectedQuestion,
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
