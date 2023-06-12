part of '/common.dart';

class FormQuestionEdit extends StatefulWidget {
  MQuestion selectedQuestion;
  FormQuestionEdit({
    required this.selectedQuestion,
    super.key,
  });

  @override
  FormQuestionEditState createState() => FormQuestionEditState();
}

class FormQuestionEditState extends State<FormQuestionEdit> {
  MQuestion get selectedQuestion => widget.selectedQuestion;

  // selectedCheck
  late String selectedMainCategory = '';

  late final TextEditingController _ctrQuestion = TextEditingController();
  late final TextEditingController _ctrAnswer = TextEditingController();
  late final TextEditingController _ctrDifficulty = TextEditingController();
  late final TextEditingController _ctrCategoryID = TextEditingController();
  late final TextEditingController _ctrInfo = TextEditingController();
  late final TextEditingController _ctrDescription = TextEditingController();
  final TStream<List<String>> $imageIDs = TStream<List<String>>();
  final TStream<List<String>> $modifyBase64Images = TStream<List<String>>();

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
                // TODO : 메인카테고리를 선택
                buildEditFields().expand(),
                // TODO : 메인 카테고리를 선택하여 해당 카테고리로 필터링한것들만 가져옴
                buildMainCategoriesFields().expand(),
                // TODO : 메인 카테고리를 parents로 가지는 서브카테고리 리스트 출력
                buildSubCategoriesFields().expand(),
                Column(
                  children: [
                    buildShowImagesFields().expand(),
                    buildEditImageFields().expand(),
                  ],
                ).expand(),
              ],
            ).expand(),
            buildElevatedButton(
              width: double.infinity,
              child: Text('complete'),
              onPressed: () async {
                RestfulResult result = await GServiceQuestion.patch(
                  id: selectedQuestion.id,
                  question: _ctrQuestion.text,
                  answer: _ctrAnswer.text,
                  categoryID: _ctrCategoryID.text,
                  // TODO : 수정된 이미지가 없으면 기존 이미지를 사용
                  images: $modifyBase64Images.lastValue == []
                      ? $imageIDs.lastValue
                      : $modifyBase64Images.lastValue,
                  info: _ctrInfo.text,
                  description: _ctrDescription.text,
                );

                if (result.statusCode != 200) {
                  showSnackBar(msg: result.message, context: context);
                  return;
                }

                // TODO : 수정이 완료되면 스트림을 갱신
                GServiceQuestion.getPagination(
                  paginationCount: GServiceQuestion.$paginationCount.lastValue,
                  paginationPage: GServiceQuestion.$paginationPage.lastValue,
                );

                // showSnackBar(msg: '문제 수정 완료', context: context);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildEditFields() {
    return Column(
      children: [
        const Text(LABEL.EDIT),
        buildTextField(
          ctr: _ctrQuestion,
          label: TEXT_FIELD.ENTER_QUESTION,
          maxLines: 5,
        ),
        buildTextField(
          ctr: _ctrAnswer,
          label: TEXT_FIELD.ENTER_ANSWER,
        ),
        buildTextField(
          ctr: _ctrInfo,
          label: '학자',
        ),
        buildTextField(
          ctr: _ctrDescription,
          label: '비고',
        ),
        // buildTextField(
        //   ctr: _ctrCategoryID,
        //   label: TEXT_FIELD.SELECT_CATEGORY,
        // ),
      ],
    );
  }

  Widget buildMainCategoriesFields() {
    return Column(
      children: [
        const Text(LABEL.SELECT_SUBJECT),
        TStreamBuilder(
          stream: GServiceMainCategory.$mainCategory.browse$,
          builder: (BuildContext context, MMainCategory mainCategory) {
            List<String> mainCategories =
                List<String>.from(mainCategory.map.keys);
            return buildBorderContainer(
              child: ListView.builder(
                itemCount: mainCategories.length,
                itemBuilder: (context, int index) {
                  return buildElevatedButton(
                    child: Text(mainCategories[index]),
                    color: selectedMainCategory == mainCategories[index]
                        ? Colors.amber
                        : Colors.blue,
                    onPressed: () {
                      setState(() {
                        if (selectedMainCategory == mainCategories[index]) {
                          selectedMainCategory = '';
                          return;
                        }

                        selectedMainCategory = mainCategories[index];
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

  Widget buildSubCategoriesFields() {
    return Column(
      children: [
        const Text(LABEL.SELECT_CATEGORY),
        TStreamBuilder(
          stream: GServiceSubCategory.$subCategory.browse$,
          builder: (
            BuildContext context,
            List<MSubCategory> subcategory,
          ) {
            // TODO : 가져옴 전체 카테고리 아이템에서 선택한 메인카테고리를 parent로 갖고 있는
            // subCategory만 필터링
            List<MSubCategory> filteredSub = subcategory
                .where((sub) => sub.parent.contains(selectedMainCategory))
                .toList();

            print('filteredSub $filteredSub');
            return buildBorderContainer(
              child: ListView.builder(
                itemCount: filteredSub.length,
                itemBuilder: (context, index) {
                  return QuestionCategoryTile(
                    selected: _ctrCategoryID.text == filteredSub[index].id,
                    name: filteredSub[index].name,
                    onChanged: (bool? changed) {
                      setState(() {
                        changed!
                            ? _ctrCategoryID.text = filteredSub[index].id
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
    );
  }

  Widget buildShowImagesFields() {
    return Column(
      children: [
        const Text(LABEL.SAVED_IMAGE),
        buildBorderContainer(
          child: TStreamBuilder(
            stream: $imageIDs.browse$,
            builder: (context, List<String> imageIDs) {
              return ListView.builder(
                itemCount: imageIDs.length,
                itemBuilder: (context, index) {
                  Future<RestfulResult> getImage =
                      GServiceQuestion.getImage(imageIDs[index]);

                  return FutureBuilder(
                    future: getImage,
                    builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
                      if (snapshot.hasData) {
                        return buildBorderContainer(
                          child: Image.memory(
                            base64Decode(snapshot.data!.data),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              );
            },
          ),
        ).expand(),
      ],
    );
  }

  Widget buildEditImageFields() {
    return Column(
      children: [
        const Text(LABEL.SELECT_IMAGE),
        buildBorderContainer(
          child: TStreamBuilder(
            stream: $modifyBase64Images.browse$,
            builder: (context, List<String> base64Images) {
              return Column(
                children: [
                  buildElevatedButton(
                    child: const Text(LABEL.SELECT_IMAGE),
                    onPressed: () async {
                      // TODO : image를 선택해서 선택한 이미지를 $base64Images에 sink
                      await selectImageFile(multiSelect: true).then((v) {
                        $modifyBase64Images.sink$(v);
                      });
                    },
                  ),
                  ListView.builder(
                    itemCount: base64Images.length,
                    itemBuilder: (context, index) {
                      return buildBorderContainer(
                        child: Image.memory(
                          base64Decode($modifyBase64Images.lastValue[index]),
                        ),
                      );
                    },
                  ).expand(),
                ],
              );
            },
          ),
        ).expand(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    MSubCategory getSubCategory =
        GServiceSubCategory.allSubCategory[selectedQuestion.categoryID]!;
    selectedMainCategory = getSubCategory.parent;

    _ctrQuestion.text = selectedQuestion.question;
    _ctrAnswer.text = selectedQuestion.answer;
    _ctrDifficulty.text = selectedQuestion.difficulty;
    _ctrCategoryID.text = selectedQuestion.categoryID;
    _ctrDescription.text = selectedQuestion.description;
    _ctrInfo.text = selectedQuestion.info;

    $imageIDs.sink$(selectedQuestion.imageIDs);
    $modifyBase64Images.sink$([]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
