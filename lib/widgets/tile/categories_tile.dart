part of '/common.dart';

abstract class CommonTile extends StatelessWidget {
  // final String name;
  // final String? parent;
  // final List<String>? children;
  final bool selected;
  final void Function(bool?)? onChanged;
  final void Function()? onPressedAction;

  CommonTile({
    // required this.name,
    // this.parent,
    // this.children,
    this.selected = false,
    this.onChanged,
    this.onPressedAction,
    super.key,
  });

  Widget buildCheckBoxCell() {
    return Checkbox(
      value: selected,
      onChanged: onChanged,
    );
  }

  Widget buildPressButton(Widget child) {
    return TextButton(
      child: child,
      onPressed: onPressedAction,
    );
  }

  Widget buildCell(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
    );
  }
}

class CategoriesTile extends CommonTile {
  String name;
  String parent;
  List<String> children;
  CategoriesTile({
    required this.name,
    required this.parent,
    required this.children,
    super.selected = false,
    required super.onChanged,
    super.onPressedAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCheckBoxCell(),
        buildCell(parent).expand(),
        buildCell(name).expand(),
        buildCell('${children}').expand(),
      ],
    );
  }
}

class QuestionCategoryTile extends CommonTile {
  String name;
  QuestionCategoryTile({
    required this.name,
    super.selected = false,
    required super.onChanged,
    super.onPressedAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCheckBoxCell(),
        buildCell(name).expand(),
      ],
    );
  }
}

class QuestionHeaderTile extends CommonTile {
  QuestionHeaderTile({
    super.selected = false,
    super.onChanged,
    super.onPressedAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCell('과목').expand(),
        buildCell('카테고리').expand(),
        buildCell('문제').expand(),
        buildCell('답안').expand(),
        buildCell('학자').expand(),
        buildCell('비고').expand(),
        buildCell('수정').expand(),
      ],
    );
  }
}

class QuestionTile extends CommonTile {
  String mainCategory;
  String subCategory;
  String question;
  String answer;
  String info;
  String description;
  Widget edit; // use icon
  QuestionTile({
    required this.mainCategory,
    required this.subCategory,
    required this.question,
    required this.answer,
    required this.edit,
    required this.info,
    required this.description,
    super.selected = false,
    super.onChanged,
    super.onPressedAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCell(mainCategory).expand(),
        buildCell(subCategory).expand(),
        buildCell(question).expand(),
        buildCell(answer).expand(),
        buildCell(info).expand(),
        buildCell(description).expand(),
        // TODO : add cell
        // ...
        buildPressButton(edit).expand(),
      ],
    );
  }
}
