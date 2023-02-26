part of '/common.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({Key? key}) : super(key: key);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final TextEditingController ctrMainCategory = TextEditingController();
  final TextEditingController ctrSubCategory = TextEditingController();
  final TextEditingController ctrTestCategory = TextEditingController();
  //
  // getter
  List<MSubCategory> get subCategories => GServiceSubCategory.subCategory;
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

  String selectedMainCategory = '';

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
                        child: Text(mainCategories[index]));
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
            label: 'sub',
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
              if (subCategories.length == 0) {
                showSnackBar(
                  msg: 'this subCategory is null',
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
                    print(subCategories[index].name);
                    return Row(
                      children: [
                        Text(subCategories[index].id),
                        Text(subCategories[index].name),
                        // Text(subCategories[index].parent),
                        // Text('${subCategories[index].children}'),
                      ],
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
            ctrTestCategory,
            label: 'input name',
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('add'),
            onPressed: () async {
              String parent = ctrSubCategory.text.isNotEmpty
                  ? ctrSubCategory.text
                  : ctrMainCategory.text;

              RestfulResult result = await GServiceSubCategory.post(
                name: ctrTestCategory.text,
                parent: parent,
                context: context,
              );
              if (result.statusCode != STATUS.SUCCESS_CODE) {
                buildErrorDialog(result.message, result.statusCode, context);
              }

              GServiceSubCategory.get(parent: parent);
            },
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('delete'),
            onPressed: () async {
              print('step1');
              RestfulResult result = await GServiceSubCategory.delete(
                id: ctrSubCategory.text,
              );
              print('step2');

              if (!result.isSuccess) {
                buildErrorDialog(
                  result.message,
                  result.statusCode,
                  context,
                );
                return;
              }

              print('step3');
              ctrSubCategory.text = '';
              GServiceSubCategory.get(parent: ctrMainCategory.text);

              print('result $result');
            },
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('textfield reset'),
            onPressed: textFieldReset,
          ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GServiceMainCategory.get();
    GServiceSubCategory.get(isSub: true);
  }

  void textFieldReset() {
    selectedMainCategory = '';
    ctrMainCategory.text = '';
    GServiceMainCategory.get();
    ctrSubCategory.text = '';
    GServiceSubCategory.get(isSub: true);
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
            GServiceSubCategory.get(isSub: true);
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
