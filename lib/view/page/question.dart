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
          TStreamBuilder(
              stream: GServiceQuestion.$questions.browse$,
              builder: (context, List<MQuestion> questions) {
                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    String categoryId = questions[index].categoryID;
                    String categoryName = getAllCategory[categoryId]!.name;
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
          Column(
            children: [
              Container(color: Colors.blueGrey).expand(),
              TStreamBuilder(
                  stream: GServiceSubCategory.$subCategory.browse$,
                  builder: (BuildContext context, _) {
                    return ListView.builder(
                      itemCount: filteredSubcategory.length,
                      itemBuilder: (context, index) {
                        return QuestionCategoryTile(
                          selected:
                              ctrCategory.text == filteredSubcategory[index].id,
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
                    );
                  }).expand(),
            ],
          ).expand(),
          Column(
            children: [
              buildTextField(
                ctrCategory,
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
