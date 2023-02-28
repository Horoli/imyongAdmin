part of '/common.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({Key? key}) : super(key: key);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final TextEditingController ctrMainCategory = TextEditingController();
  final TextEditingController ctrSubCategory = TextEditingController();
  final TextEditingController ctrInputCategory = TextEditingController();
  // selectedCheck
  String selectedMainCategory = '';
  // getter
  List<MSubCategory> get subCategories => GServiceSubCategory.subCategory;

  //
  List<String> selectedCategoriesId = [];
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
            width: double.infinity,
            onPressed: () async {
              buildCategoriesDialog(createMainCategories());
            },
            child: Text('main'),
          ).expand(),
          Padding(
            padding: commonPadding,
            child: TStreamBuilder(
              stream: GServiceMainCategory.$mainCategory.browse$,
              builder: (BuildContext context, MMainCategory category) {
                List<String> mainCategories =
                    List<String>.from(category.map.values);
                print('mainCategories $mainCategories');

                return ListView.builder(
                  itemCount: mainCategories.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      color: selectedMainCategory == mainCategories[index]
                          ? Colors.amber
                          : Colors.blue,
                      child: Text(
                        mainCategories[index],
                      ),
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
            ctrSubCategory,
            readOnly: true,
            label: 'subcategory',
            hint: 'select subcategory',
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('cancel'),
            onPressed: () {
              ctrSubCategory.clear();
              GServiceSubCategory.get(parent: ctrMainCategory.text);
            },
          ).expand(),
          buildElevatedButton(
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
            },
          ).expand(),
          Padding(
            padding: commonPadding,
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
                      name: subCategories[index].name,
                      parent: parentName,
                      children: childrenName,
                      selected: selectedCategoriesId
                          .contains(subCategories[index].id),
                      onChanged: (bool? changed) {
                        setState(() {
                          changed!
                              ? selectedCategoriesId
                                  .add(subCategories[index].id)
                              : selectedCategoriesId
                                  .remove(subCategories[index].id);
                        });
                        print('selectedCategoriesId $selectedCategoriesId');

                        print('changed $changed');
                      },
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

  Widget buildEditButtons() {
    return buildBorderContainer(
      child: Column(
        children: [
          buildTextField(
            ctrInputCategory,
            label: 'Enter category name',
            hint: 'Enter category name',
          ).expand(),
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
                return;
              }

              late RestfulResult result;

              for (String id in selectedCategoriesId) {
                result = await GServiceSubCategory.delete(id: id);
                //
              }

              if (!result.isSuccess) {
                buildErrorDialog(
                  result.message,
                  result.statusCode,
                  context,
                );
                return;
              }
              // RestfulResult result = await GServiceSubCategory.delete(
              //   id: ctrSubCategory.text,
              // );
              // print('step2');

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
            onPressed: fieldReset,
          ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceSubCategory.getAll();
    GServiceSubCategory.get();
  }

  void fieldReset() {
    selectedMainCategory = '';
    GServiceMainCategory.get();
    GServiceSubCategory.getAll();
    GServiceSubCategory.get();
    ctrMainCategory.clear();
    ctrSubCategory.clear();
    ctrInputCategory.clear();
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
              return Navigator.pop(context);
            }
            GServiceSubCategory.get();
            return Navigator.pop(context);
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
