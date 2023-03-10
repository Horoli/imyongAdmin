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
        buildCell(name).expand(),
        buildCell(parent).expand(),
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

class QuestionTile extends CommonTile {
  String question;
  String answer;
  String category;
  Widget edit; // use icon
  QuestionTile({
    required this.question,
    required this.category,
    required this.answer,
    required this.edit,
    super.selected = false,
    super.onChanged,
    super.onPressedAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCell(question).expand(),
        buildCell(answer).expand(),
        buildCell(category).expand(),
        // TODO : add cell
        // ...
        buildPressButton(edit).expand(),
      ],
    );
  }
}
