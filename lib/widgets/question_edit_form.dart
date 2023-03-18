part of '/common.dart';

class FormQuestionEdit extends StatefulWidget {
  MQuestion? selectedQuestion;
  FormQuestionEdit({
    this.selectedQuestion,
    super.key,
  });

  @override
  FormQuestionEditState createState() => FormQuestionEditState();
}

class FormQuestionEditState extends State<FormQuestionEdit> {
  // selectedCheck
  String selectedMainCategory = '';

  late final TextEditingController _ctrQuestion =
      TextEditingController(text: widget.selectedQuestion!.question);
  late final TextEditingController _ctrAnswer =
      TextEditingController(text: widget.selectedQuestion!.answer);
  late final TextEditingController _ctrDifficulty =
      TextEditingController(text: widget.selectedQuestion!.difficulty);
  late final TextEditingController _ctrCategoryID =
      TextEditingController(text: widget.selectedQuestion!.categoryID);
  // List<MSubCategory> get subcategory => GServiceSubCategory.subCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 1000,
        height: 800,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('edit'),
                    buildTextField(
                      ctr: _ctrQuestion,
                      label: 'question',
                    ),
                    buildTextField(
                      ctr: _ctrAnswer,
                      label: 'answer',
                    ),
                    buildTextField(
                      ctr: _ctrDifficulty,
                      label: 'difficulty',
                    ),
                    buildTextField(
                      ctr: _ctrCategoryID,
                      label: 'category',
                    ),
                  ],
                ).expand(),
                // TODO : 메인카테고리를 선택
                Column(
                  children: [
                    Text('select Subject(mainCategory)'),
                    TStreamBuilder(
                      stream: GServiceMainCategory.$mainCategory.browse$,
                      builder:
                          (BuildContext context, MMainCategory mainCategory) {
                        List<String> mainCategories =
                            List<String>.from(mainCategory.map.keys);
                        return buildBorderContainer(
                          child: ListView.builder(
                            itemCount: mainCategories.length,
                            itemBuilder: (context, int index) {
                              return buildElevatedButton(
                                child: Text(mainCategories[index]),
                                color: selectedMainCategory ==
                                        mainCategories[index]
                                    ? Colors.amber
                                    : Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    selectedMainCategory =
                                        mainCategories[index];
                                  });
                                },
                              );
                            },
                          ),
                        );
                      },
                    ).expand(),
                  ],
                ).expand(),
                // TODO : 메인 카테고리를 선택하여 해당 카테고리로 필터링한것들만 가져옴
                Column(
                  children: [
                    Text('select category'),
                    TStreamBuilder(
                      stream: GServiceSubCategory.$subCategory.browse$,
                      builder: (
                        BuildContext context,
                        List<MSubCategory> subcategory,
                      ) {
                        // TODO : 가져옴 전체 카테고리 아이템에서 선택한 메인카테고리를 parent로 갖고 있는
                        // subCategory만 필터링
                        List<MSubCategory> filteredSub = subcategory
                            .where((sub) =>
                                sub.parent.contains(selectedMainCategory))
                            .toList();

                        print('filteredSub $filteredSub');
                        return buildBorderContainer(
                          child: ListView.builder(
                            itemCount: filteredSub.length,
                            itemBuilder: (context, index) {
                              return QuestionCategoryTile(
                                selected: _ctrCategoryID.text ==
                                    filteredSub[index].id,
                                name: filteredSub[index].name,
                                onChanged: (bool? changed) {
                                  setState(() {
                                    changed!
                                        ? _ctrCategoryID.text =
                                            filteredSub[index].id
                                        : _ctrCategoryID.text = '';
                                  });
                                },
                              );
                            },
                          ),
                        );
                      },
                    ).expand(),
                  ],
                ).expand(),
              ],
            ).expand(),
            buildElevatedButton(
              width: double.infinity,
              child: Text('complete'),
              onPressed: () {
                GServiceQuestion.patch(
                  id: widget.selectedQuestion!.id,
                  question: _ctrQuestion.text,
                  answer: _ctrAnswer.text,
                  categoryID: _ctrCategoryID.text,
                );
              },
            )
          ],
        ),
      ),
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
