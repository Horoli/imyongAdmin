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

  //
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          buildBorderContainer(
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
          ).expand(),
          buildBorderContainer(
            child: Column(
              children: [
                buildTextField(label: 'enter question'),
                buildTextField(label: 'enter answer'),
                buildTextField(label: 'enter score'),
                buildElevatedButton(
                  width: double.infinity,
                  child: Text('select difficulty'),
                  onPressed: () {
                    buildCategoriesDialog(create());
                  },
                ).expand(),
                const Text('selectCategory'),
                buildCategoriesTile().expand(),
              ],
            ),
          ).expand(),
          buildBorderContainer(
            child: Column(
              children: [
                buildTextField(
                  ctr: ctrCategory,
                  label: 'selectedCategory ID',
                  readOnly: true,
                ),
                buildElevatedButton(
                  child: Text('post'),
                  onPressed: () async {
                    GServiceQuestion.post(categoryID: ctrCategory.text);
                  },
                ).expand(),
                buildElevatedButton(
                  child: Text('dialog'),
                  onPressed: () async {
                    // buildCategoriesDialog(create());
                  },
                ).expand(),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildCategoriesTile({bool isEdit = false}) {
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

  List<SimpleDialogOption> create() {
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
