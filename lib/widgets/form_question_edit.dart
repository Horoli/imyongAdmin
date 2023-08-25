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
  late final TextEditingController _ctrcategoryId = TextEditingController();
  late final TextEditingController _ctrInfo = TextEditingController();
  late final TextEditingController _ctrDescription = TextEditingController();
  final TStream<List<String>> $imageIds = TStream<List<String>>();
  final TStream<List<String>> $modifyBase64Images = TStream<List<String>>();

  final TStream<String> $selectedMainCategory = TStream<String>()..sink$('');
  final TStream<MSubCategory> $selectedSubCategory = TStream<MSubCategory>()
    ..sink$(emptySubCategory);
  final TStream<MSubCategory> $selectedSubInSubCategory =
      TStream<MSubCategory>()..sink$(emptySubCategory);

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
                Column(
                  children: [
                    FutureBuilder(
                        future: initFuture(),
                        builder: (
                          context,
                          AsyncSnapshot<Map<String, MSubCategory>> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            Map<String, MSubCategory> categories =
                                snapshot.data!;

                            print(categories['subInSub']!.name);
                            print(categories['sub']!.name);
                            print(categories['sub']!.parent);

                            $selectedSubInSubCategory
                                .sink$(categories['subInSub']!);
                            $selectedSubCategory.sink$(categories['sub']!);
                            $selectedMainCategory
                                .sink$(categories['sub']!.parent);

                            return TStreamBuilder(
                                stream: $selectedMainCategory.browse$,
                                builder: (context, snapshot) {
                                  print('snapshot $snapshot');
                                  return WidgetCategoriesSelect(
                                    // isVertical: true,
                                    $selectedMainCategory:
                                        $selectedMainCategory,
                                    $selectedSubCategory: $selectedSubCategory,
                                    $selectedSubInSubCategory:
                                        $selectedSubInSubCategory,
                                  );
                                });
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }).expand(),
                    Row(
                      children: [
                        buildEditImageFields().expand(),
                        buildShowImagesFields().expand(),
                      ],
                    ).expand(),
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
                  categoryId: $selectedSubInSubCategory.lastValue.id,
                  // TODO : 수정된 이미지가 없으면 기존 이미지를 사용
                  images: $modifyBase64Images.lastValue == []
                      ? $imageIds.lastValue
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
                  showPaginationCount:
                      GServiceQuestion.$showPaginationCount.lastValue,
                  selectedpaginationPage:
                      GServiceQuestion.$selectedPaginationPage.lastValue,
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
        //   ctr: _ctrcategoryId,
        //   label: TEXT_FIELD.SELECT_CATEGORY,
        // ),
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

  Widget buildShowImagesFields() {
    return Column(
      children: [
        const Text(LABEL.SAVED_IMAGE),
        buildBorderContainer(
          child: TStreamBuilder(
            stream: $imageIds.browse$,
            builder: (context, List<String> imageIds) {
              return ListView.builder(
                itemCount: imageIds.length,
                itemBuilder: (context, index) {
                  Future<RestfulResult> getImage =
                      GServiceQuestion.getImage(imageIds[index]);

                  return FutureBuilder(
                    future: getImage,
                    builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
                      if (snapshot.hasData) {
                        print('pppppppppppppppp ${snapshot.data!.data}');
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

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<Map<String, MSubCategory>> initFuture() async {
    RestfulResult firstResult = await GServiceSubCategory.getById(
        id: widget.selectedQuestion.categoryId);
    print('step 1');
    MSubCategory getSubInSubCategory = firstResult.data!;
    print('step 2');
    RestfulResult secondResult =
        await GServiceSubCategory.getById(id: getSubInSubCategory.parent);
    print('step 3');
    MSubCategory getSubCategory = secondResult.data!;

    print('getSubCategory ${getSubCategory.id}');

    Map<String, MSubCategory> categories = {
      'sub': getSubCategory,
      'subInSub': getSubInSubCategory,
    };

    return categories;
  }

  Future initData() async {
    _ctrQuestion.text = selectedQuestion.question;
    _ctrAnswer.text = selectedQuestion.answer;
    _ctrDifficulty.text = selectedQuestion.difficulty;
    _ctrcategoryId.text = selectedQuestion.categoryId;
    _ctrDescription.text = selectedQuestion.description;
    _ctrInfo.text = selectedQuestion.info;

    print('selectedQuestion.imageIds ${selectedQuestion.imageIds}');
    $imageIds.sink$(selectedQuestion.imageIds);
    $modifyBase64Images.sink$([]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
