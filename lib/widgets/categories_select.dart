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

                              // GServiceMainCategory.$selectedCategory.sink$('');
                              // GServiceSubCategory.$selectedSubCategory
                              // .sink$(emptySubCategory);
                              // GServiceSubCategory.$selectedSubInSubCategory
                              //     .sink$(emptySubCategory);
                              return;
                            }

                            $selectedMainCategory.sink$(keyOfMainCategory);
                            $selectedSubCategory.sink$(emptySubCategory);
                            $selectedSubInSubCategory.sink$(emptySubCategory);

                            // TODO : 다른 값을 눌렀을때 서브 카테고리 초기화
                            // GServiceMainCategory.$selectedCategory
                            //     .sink$(keyOfMainCategory);
                            // GServiceSubCategory.$selectedSubCategory
                            //     .sink$(emptySubCategory);
                            // GServiceSubCategory.$selectedSubInSubCategory
                            //     .sink$(emptySubCategory);
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
                // stream: GServiceSubCategory.$selectedSubCategory.browse$,
                builder: (context, MSubCategory selectedSubCategory) {
                  return FutureBuilder(
                    future:
                        GServiceSubCategory.get(parent: selectedMainCategory),
                    builder: (context, AsyncSnapshot<RestfulResult> snapshot) {
                      // print('selectedSubCategory ${snapshot.data?.data}');
                      // print('hasData ${snapshot.hasData}');
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
                                // GServiceSubCategory.$selectedSubCategory
                                //     .sink$(subCategories[index]);
                                // GServiceSubCategory.$selectedSubInSubCategory
                                //     .sink$(emptySubCategory);
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
            // stream: GServiceSubCategory.$selectedSubCategory.browse$,
            builder: (context, MSubCategory selectedSubCategory) {
              return TStreamBuilder(
                stream: $selectedSubInSubCategory.browse$,
                // stream: GServiceSubCategory.$selectedSubInSubCategory.browse$,
                builder: (context, MSubCategory selectedSubInSubCategory) {
                  return FutureBuilder(
                    future:
                        GServiceSubCategory.get(parent: selectedSubCategory.id),
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
                                if (selectedSubInSubCategory.id == indexId) {
                                  $selectedSubInSubCategory
                                      .sink$(emptySubCategory);

                                  // GServiceSubCategory.$selectedSubInSubCategory
                                  //     .sink$(emptySubCategory);
                                  return;
                                }

                                $selectedSubInSubCategory
                                    .sink$(subCategories[index]);
                                // GServiceSubCategory.$selectedSubInSubCategory
                                //     .sink$(subCategories[index]);
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
    // GServiceMainCategory.$selectedCategory.sink$('');
    // GServiceSubCategory.$selectedSubCategory.sink$(emptySubCategory);
    // GServiceSubCategory.$selectedSubInSubCategory.sink$(emptySubCategory);

    $selectedMainCategory.sink$('');
    $selectedSubCategory.sink$(emptySubCategory);
    $selectedSubInSubCategory.sink$(emptySubCategory);
  }
}
