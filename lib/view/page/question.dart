part of '/common.dart';

class ViewQuestion extends StatefulWidget {
  const ViewQuestion({Key? key}) : super(key: key);

  @override
  _ViewQuestionState createState() => _ViewQuestionState();
}

class _ViewQuestionState extends State<ViewQuestion> {
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
                          String categoryId = questions[index].categoryID;
                          String categoryName = '';
                          if (categoryId != '') {
                            categoryName = getAllCategory[categoryId]!.name;
                          }

                          // return QuestionTile(
                          //   name: ,
                          //   question: questions[index].question,
                          //   answer: questions[index].answer,
                          //   edit: ';',
                          //   onChanged: onChanged,
                          // );

                          return Row(
                            children: [
                              Text(questions[index].question).expand(),
                              Text(questions[index].answer).expand(),
                              Text(categoryName).expand(),
                            ],
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
                  onPressed: () {},
                ).expand(),
                const Text('selectCategory'),
                TStreamBuilder(
                    stream: GServiceSubCategory.$subCategory.browse$,
                    builder: (BuildContext context, _) {
                      return buildBorderContainer(
                        child: ListView.builder(
                          itemCount: filteredSubcategory.length,
                          itemBuilder: (context, index) {
                            return QuestionCategoryTile(
                              selected: ctrCategory.text ==
                                  filteredSubcategory[index].id,
                              name: filteredSubcategory[index].name,
                              onChanged: (bool? changed) {
                                setState(() {
                                  changed!
                                      ? ctrCategory.text =
                                          filteredSubcategory[index].id
                                      : ctrCategory.text = '';
                                });
                              },
                            );
                          },
                        ),
                      );
                    }).expand(),
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
                    buildCategoriesDialog(create());
                  },
                ).expand(),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildShowQuestions() {
    return TStreamBuilder(
        stream: GServiceQuestion.$questions.browse$,
        builder: (context, List<MQuestion> questions) {
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text(questions[index].question).expand(),
                  Text(questions[index].answer).expand(),
                  Text(questions[index].categoryID).expand(),
                ],
              );
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
    GServiceSubCategory.get(isNoChildren: true);
    GServiceSubCategory.getAll();
    GServiceQuestion.get();
  }

  Future<void> buildCategoriesDialog(List<Widget> categories) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: categories);
      },
    );
  }

  List<SimpleDialogOption> create() {
    return List.generate(
      filteredSubcategory.length,
      (int index) {
        return SimpleDialogOption(
          child: Row(
            children: [
              Text(filteredSubcategory[index].name),
              Text(filteredSubcategory[index].name),
            ],
          ),
          onPressed: () {
            ctrCategory.text = filteredSubcategory[index].id;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
