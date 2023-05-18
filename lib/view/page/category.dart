part of '/common.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({super.key});

  @override
  ViewCategoryState createState() => ViewCategoryState();
}

class ViewCategoryState extends State<ViewCategory> {
  final TextEditingController ctrMainCategory = TextEditingController();
  final TextEditingController ctrSubCategory = TextEditingController();
  final TextEditingController ctrInputCategory = TextEditingController();
  // selectedCheck
  String selectedMainCategory = '';
  // getter
  List<MSubCategory> get subCategories => GServiceSubCategory.subCategory;

  //
  List<String> get selectedCategoriesId =>
      GServiceSubCategory.selectedCategoriesId;
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Row(
        children: [
          // TODO : main
          buildManagementMainCategory().expand(),
          // TODO : sub
          buildManagementSubCategory().expand(),
          // TODO : edit
          buildEditButtons().expand(),
        ],
      ),
    );
  }

  Widget buildManagementMainCategory() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildElevatedButton(
            color: selectedMainCategory == '' || selectedMainCategory == '취소'
                ? Theme.of(context).primaryColor
                : Colors.amber,
            width: double.infinity,
            onPressed: () async {
              buildCategoriesDialog(createMainCategories());
            },
            child: Text('select mainCategory'),
          ).expand(),
          Padding(
            padding: commonPadding,
            child: TStreamBuilder(
              stream: GServiceMainCategory.$mainCategory.browse$,
              builder: (BuildContext context, MMainCategory category) {
                List<String> mainCategories =
                    List<String>.from(category.map.values);
                print('mainCategories $mainCategories');
                print('selectedMainCategory $selectedMainCategory');

                return ListView.builder(
                  itemCount: mainCategories.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      color: selectedMainCategory == mainCategories[index]
                          ? Colors.amber
                          : Colors.blue,
                      child: Text(mainCategories[index]),
                    );
                  },
                );
              },
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildManagementSubCategory() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildTextField(
            ctr: ctrSubCategory,
            readOnly: true,
            label: 'subcategory',
            hint: 'select subcategory',
          ),
          Row(
            children: [
              buildElevatedButton(
                height: double.infinity,
                width: double.infinity,
                child: Text('select SubCategory'),
                onPressed: () async {
                  if (ctrMainCategory.text == '') {
                    showSnackBar(
                      msg: 'please select mainCategory',
                      context: context,
                    );
                    return;
                  }
                  if (subCategories.isEmpty) {
                    showSnackBar(
                      msg: 'null',
                      context: context,
                    );
                    return;
                  }
                  buildCategoriesDialog(createSubCategories());
                  // selectedCategoriesId = [];
                },
              ).expand(),
              buildElevatedButton(
                height: double.infinity,
                width: double.infinity,
                child: Text('deselect SubCategory'),
                onPressed: () {
                  // TODO : subCategory 선택 초기화를 하면 mainCategory를 선택한
                  // 데이터를 다시 가져옴
                  ctrSubCategory.clear();
                  GServiceSubCategory.get(parent: ctrMainCategory.text);
                },
              ).expand(),
            ],
          ).expand(flex: 2),
          buildBorderContainer(
            child: TStreamBuilder(
              stream: GServiceSubCategory.$subCategory.browse$,
              builder: (
                BuildContext context,
                List<MSubCategory> subCategories,
              ) {
                return ListView.builder(
                  itemCount: subCategories.length,
                  itemBuilder: (context, int index) {
                    // TODO : parent key를 활용해서 name을 가져옴
                    String parentKey = subCategories[index].parent;
                    bool hasParentKey = GServiceSubCategory.allSubCategory
                        .containsKey(parentKey);
                    String parentName = hasParentKey
                        ? GServiceSubCategory.allSubCategory[parentKey]!.name
                        : parentKey;

                    // TODO : children key를 활용해서 name을 가져옴
                    List<String> children = subCategories[index].children;
                    print('children $children');
                    List<String> childrenName = [];
                    for (var childrenKey in children) {
                      bool hasChildrenKey = GServiceSubCategory.allSubCategory
                          .containsKey(childrenKey);
                      if (hasChildrenKey) {
                        childrenName.add(GServiceSubCategory
                            .allSubCategory[childrenKey]!.name);
                      }
                    }

                    // TODO : checkBox 생성 후 해당 id 체크하면
                    // selectedSubCategory에 저장하고
                    // delete 버튼 누르면 삭제 할 수 있게 기능 추가
                    return CategoriesTile(
                      parent: parentName,
                      name: subCategories[index].name,
                      children: childrenName,
                      selected: selectedCategoriesId
                          .contains(subCategories[index].id),
                      onChanged: (bool? changed) {
                        // TODO : categories를 다중 선택해서 삭제
                        setState(() {
                          if (ctrMainCategory.text == '') {
                            showSnackBar(
                              msg: 'please select mainCategory',
                              context: context,
                            );
                            return;
                          }

                          changed!
                              ? selectedCategoriesId
                                  .add(subCategories[index].id)
                              : selectedCategoriesId
                                  .remove(subCategories[index].id);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ).expand(flex: 10),
        ],
      ),
    );
  }

  Widget buildEditButtons() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildTextField(
            ctr: ctrInputCategory,
            label: 'Enter category name',
            hint: 'Enter category name',
          ),
          buildElevatedButton(
            width: double.infinity,
            child: Text('add'),
            onPressed: () async {
              String parent = ctrSubCategory.text.isNotEmpty
                  ? ctrSubCategory.text
                  : ctrMainCategory.text;

              RestfulResult result = await GServiceSubCategory.post(
                name: ctrInputCategory.text,
                parent: parent,
                context: context,
              );

              //
              if (result.statusCode != STATUS.SUCCESS_CODE) {
                buildErrorDialog(result.message, result.statusCode, context);
              }

              GServiceSubCategory.getAll();
              GServiceSubCategory.get(parent: parent);
            },
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('delete'),
            onPressed: () async {
              print('step1');

              if (selectedCategoriesId.isEmpty) {
                buildErrorDialog(
                  'selectedCategory is empty.',
                  403,
                  context,
                );
                return;
              }

              late RestfulResult result;

              for (String id in selectedCategoriesId) {
                result = await GServiceSubCategory.delete(id: id);
                //
              }

              if (!result.isSuccess) {
                print('result $result');
                buildErrorDialog(
                  result.message,
                  result.statusCode,
                  context,
                );
                return;
              }

              print('step3');
              ctrSubCategory.text = '';
              GServiceSubCategory.getAll();
              GServiceSubCategory.get(parent: ctrMainCategory.text);

              print('result $result');
            },
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('reset'),
            onPressed: resetFunction,
          ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future _initData() async {
    await GServiceMainCategory.get();
    await GServiceSubCategory.getAll();
    await GServiceSubCategory.get();
  }

  void resetFunction() {
    setState(() {
      selectedMainCategory = '';
      GServiceMainCategory.get();
      GServiceSubCategory.getAll();
      GServiceSubCategory.get();
      ctrMainCategory.clear();
      ctrSubCategory.clear();
      ctrInputCategory.clear();
      // selectedCategoriesId = [];
    });
  }

  Future<void> buildCategoriesDialog(List<Widget> categories) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: categories);
      },
    );
  }

  List<SimpleDialogOption> createMainCategories() {
    Map<String, String> mainCategories =
        Map<String, String>.from(GServiceMainCategory.mainCategory.map);
    print(mainCategories);

    mainCategories[''] = '취소';
    return List.generate(
      mainCategories.length,
      (int index) {
        return SimpleDialogOption(
          child: Text(mainCategories.values.toList()[index]),
          onPressed: () {
            setState(() {
              selectedMainCategory = mainCategories.values.toList()[index];
              ctrMainCategory.text = mainCategories.keys.toList()[index];

              // TODO : stream refesh
              GServiceMainCategory.$mainCategory
                  .sink$(GServiceMainCategory.mainCategory);
              print('check ${ctrMainCategory.text == selectedMainCategory}');
              // TODO : 메인 카테고리를 선택하면 서브 카테고리 선택 초기화
              ctrSubCategory.text = '';
              print(ctrMainCategory.text);
              if (ctrMainCategory.text != '') {
                GServiceSubCategory.get(parent: ctrMainCategory.text);
                // selectedCategoriesId = [];
                return Navigator.pop(context);
              }
              GServiceSubCategory.get();
              // selectedCategoriesId = [];
              return Navigator.pop(context);
            });
          },
        );
      },
    );
  }

  List<SimpleDialogOption> createSubCategories() {
    return List.generate(
      subCategories.length,
      (index) => SimpleDialogOption(
        child: Row(
          children: [
            Text(subCategories[index].id).expand(),
            Text(subCategories[index].name).expand(),
          ],
        ),
        onPressed: () {
          ctrSubCategory.text = subCategories[index].id;
          GServiceSubCategory.get(parent: ctrSubCategory.text);
          Navigator.pop(context);
        },
      ),
    );
  }
}
