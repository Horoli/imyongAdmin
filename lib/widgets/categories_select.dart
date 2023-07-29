part of '/common.dart';

class WidgetCategoriesSelect extends StatefulWidget {
  TStream<String>? $selectedMainCategory;
  TStream<MSubCategory>? $selectedSubCategory;
  TStream<MSubCategory>? $selectedSubInSubCategory;

  bool isVertical;
  WidgetCategoriesSelect({
    this.isVertical = false,
    this.$selectedMainCategory,
    this.$selectedSubCategory,
    this.$selectedSubInSubCategory,
    super.key,
  });

  @override
  WidgetCategoriesSelectState createState() => WidgetCategoriesSelectState();
}

class WidgetCategoriesSelectState extends State<WidgetCategoriesSelect> {
  late final TStream<String> $selectedMainCategory =
      widget.$selectedMainCategory ?? TStream<String>();
  late final TStream<MSubCategory> $selectedSubCategory =
      widget.$selectedSubCategory ?? TStream<MSubCategory>();
  late final TStream<MSubCategory> $selectedSubInSubCategory =
      widget.$selectedSubInSubCategory ?? TStream<MSubCategory>();

  @override
  Widget build(BuildContext context) {
    return widget.isVertical
        ? Column(
            children: [
              buildSelectMainCategory().expand(),
              buildSelectSubCategory().expand(),
              buildSelectSubInSubCategory().expand(),
            ],
          )
        : Row(
            children: [
              buildSelectMainCategory().expand(),
              buildSelectSubCategory().expand(),
              buildSelectSubInSubCategory().expand(),
            ],
          );
  }

  Widget buildSelectMainCategory() {
    return buildBorderContainer(
      child: Column(
        children: [
          const Center(child: Text('main category')),
          FutureBuilder(
            future: GServiceMainCategory.get(),
            builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
              if (snapshot.hasData) {
                MMainCategory snapshotData = snapshot.data?.data;

                Map<String, String> mainCategories = Map.from(snapshotData.map);

                return TStreamBuilder(
                  // stream: GServiceMainCategory.$selectedCategory.browse$,
                  stream: $selectedMainCategory.browse$,
                  builder: (context, String selectedMainCategory) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: mainCategories.length,
                      itemBuilder: (context, int index) {
                        String keyOfMainCategory =
                            mainCategories.keys.toList()[index];
                        String valueOfMainCategory =
                            mainCategories.values.toList()[index];

                        return buildElevatedButton(
                          child: Center(child: Text(valueOfMainCategory)),
                          color: selectedMainCategory == keyOfMainCategory
                              ? Colors.amber
                              : Colors.blue,
                          onPressed: () async {
                            // 두번 누르면 빈값을 set
                            if (selectedMainCategory == keyOfMainCategory) {
                              $selectedMainCategory.sink$('');
                              $selectedSubCategory.sink$(emptySubCategory);
                              $selectedSubInSubCategory.sink$(emptySubCategory);
                              return;
                            }

                            $selectedMainCategory.sink$(keyOfMainCategory);
                            $selectedSubCategory.sink$(emptySubCategory);
                            $selectedSubInSubCategory.sink$(emptySubCategory);
                          },
                        ).sizedBox(height: kToolbarHeight);
                      },
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ).expand(),
        ],
      ),
    );
  }

  Widget buildSelectSubCategory() {
    return buildBorderContainer(
      child: Column(
        children: [
          const Center(child: Text('subcategory')),
          TStreamBuilder(
            stream: $selectedMainCategory.browse$,
            // stream: GServiceMainCategory.$selectedCategory.browse$,
            builder: (context, String selectedMainCategory) {
              return TStreamBuilder(
                stream: $selectedSubCategory.browse$,
                builder: (context, MSubCategory selectedSubCategory) {
                  return FutureBuilder(
                    future: GServiceSubCategory.getByParent(
                        parent: selectedMainCategory),
                    builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
                      if (snapshot.data?.data != null) {
                        List<MSubCategory> subCategories = snapshot.data?.data;
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: subCategories.length,
                          itemBuilder: (context, int index) {
                            return buildElevatedButton(
                              child: Text(subCategories[index].name),
                              color: selectedSubCategory.id ==
                                      subCategories[index].id
                                  ? Colors.amber
                                  : Colors.blue,
                              onPressed: () {
                                $selectedSubCategory
                                    .sink$(subCategories[index]);
                                $selectedSubInSubCategory
                                    .sink$(emptySubCategory);
                              },
                            ).sizedBox(height: kToolbarHeight);
                          },
                        );
                      }
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                          Center(child: Text(LABEL.SELECT_SUBCATEGORY))
                        ],
                      );
                    },
                  );
                },
              );
            },
          ).expand(),
        ],
      ),
    );
  }

  Widget buildSelectSubInSubCategory() {
    return buildBorderContainer(
      child: Column(
        children: [
          const Center(child: Text('sub in subcategory')),
          TStreamBuilder(
            stream: $selectedSubCategory.browse$,
            builder: (context, MSubCategory selectedSubCategory) {
              return TStreamBuilder(
                stream: $selectedSubInSubCategory.browse$,
                builder: (context, MSubCategory selectedSubInSubCategory) {
                  return FutureBuilder(
                    future: GServiceSubCategory.getByParent(
                        parent: selectedSubCategory.id),
                    builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
                      if (snapshot.data?.data != null) {
                        List<MSubCategory> subCategories = snapshot.data?.data;
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: subCategories.length,
                          itemBuilder: (context, int index) {
                            String indexId = subCategories[index].id;

                            return buildElevatedButton(
                              child: Text(subCategories[index].name),
                              color: selectedSubInSubCategory.id == indexId
                                  ? Colors.amber
                                  : Colors.blue,
                              onPressed: () {
                                // TODO : category에서는 sub in subCategory를 변경하지 못하게 버튼 disable

                                if (widget.$selectedSubInSubCategory != null) {
                                  if (selectedSubInSubCategory.id == indexId) {
                                    $selectedSubInSubCategory
                                        .sink$(emptySubCategory);

                                    return;
                                  }

                                  $selectedSubInSubCategory
                                      .sink$(subCategories[index]);
                                }
                              },
                            ).sizedBox(height: kToolbarHeight);
                          },
                        );
                      }
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                          Center(child: Text(LABEL.SELECT_SUB_IN_SUBCATEGORY))
                        ],
                      );
                    },
                  );
                },
              );
            },
          ).expand(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    if (widget.$selectedMainCategory == null) {
      $selectedMainCategory.sink$('');
      $selectedSubCategory.sink$(emptySubCategory);
      $selectedSubInSubCategory.sink$(emptySubCategory);
    }
  }
}
