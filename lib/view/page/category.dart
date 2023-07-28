part of '/common.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({super.key});

  @override
  ViewCategoryState createState() => ViewCategoryState();
}

class ViewCategoryState extends State<ViewCategory> {
  final TextEditingController ctrMainCategory = TextEditingController();
  final TextEditingController ctrSubCategory = TextEditingController();
  final TextEditingController ctrInputCategoryName = TextEditingController();
  final TextEditingController ctrSelectedMainCategory = TextEditingController();
  final TextEditingController ctrSelectedSubCategory = TextEditingController();

  List<MSubCategory> get subCategories => GServiceSubCategory.subCategory;

  final TStream<MSubCategory> $selectedSubCategory = TStream<MSubCategory>()
    ..sink$(emptySubCategory);

  //
  List<String> get selectedCategoriesId =>
      GServiceSubCategory.selectedCategoriesId;
  @override
  Widget build(BuildContext context) {
    //
    return buildBorderContainer(
      child: Column(
        children: [
          WidgetCategoriesSelect($selectedSubCategory: $selectedSubCategory)
              .expand(),
          TStreamBuilder(
            stream: GServiceMainCategory.$selectedCategory.browse$,
            builder: (context, String selectedCategory) {
              if (selectedCategory.isEmpty) {
                return buildBorderContainer(
                  child: const Center(
                    child: Text('please select main category'),
                  ),
                ).expand();
              }
              return buildEditButtons(selectedCategory).expand();
            },
          ),
        ],
      ),
    );
  }

  Widget buildEditButtons(String selectedCategory) {
    ctrSelectedMainCategory.text =
        GServiceMainCategory.mainCategory.map[selectedCategory];
    return buildBorderContainer(
      child: Column(
        children: [
          buildTextField(
            ctr: ctrSelectedMainCategory,
            label: 'selected MainCategory name',
            hint: 'selected MainCategory name',
            readOnly: true,
          ),
          TStreamBuilder(
              stream: $selectedSubCategory.browse$,
              builder: (context, MSubCategory selectedSubCategory) {
                ctrSelectedSubCategory.text = selectedSubCategory.name;
                return buildTextField(
                  ctr: ctrSelectedSubCategory,
                  label: 'selected Subcategory name',
                  hint: 'selected Subcategory name',
                  readOnly: true,
                );
              }),
          buildTextField(
            ctr: ctrInputCategoryName,
            label: 'Enter category name',
            hint: 'Enter category name',
          ),
          buildElevatedButton(
            width: double.infinity,
            child: Text('add'),
            onPressed: () async {
              MSubCategory parent = $selectedSubCategory.lastValue;

              RestfulResult result = await GServiceSubCategory.post(
                name: ctrInputCategoryName.text,
                parent: parent.id,
              );

              if (result.statusCode != STATUS.SUCCESS_CODE) {
                buildErrorDialog(result.message, result.statusCode, context);
              }

              GServiceSubCategory.$selectedSubCategory.sink$(parent);
            },
          ).expand(),
          buildElevatedButton(
            width: double.infinity,
            child: Text('delete'),
            onPressed: () async {
              print('step1');

              if (selectedCategoriesId.isEmpty) {
                buildErrorDialog('selectedCategory is empty.', 403, context);
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
          // buildElevatedButton(
          //   width: double.infinity,
          //   child: Text('reset'),
          // onPressed: resetFunction,
          // ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // GServiceMainCategory.get();
    super.initState();
    // _initData();
  }

  @override
  void dispose() {
    super.dispose();
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
