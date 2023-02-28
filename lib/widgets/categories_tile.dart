part of '/common.dart';

abstract class CategoriesCommonTile extends StatelessWidget {
  final String name;
  final String parent;
  final List<String> children;
  final bool selected;
  final void Function(bool?) onChanged;
  final void Function()? onPressedAction;

  CategoriesCommonTile({
    required this.name,
    required this.parent,
    this.selected = false,
    required this.children,
    required this.onChanged,
    this.onPressedAction,
    super.key,
  });

  Widget buildCheckBoxCell() {
    return Checkbox(
      value: selected,
      onChanged: onChanged,
    );
  }

  Widget buildCell(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
    );
  }
}

class CategoriesTile extends CategoriesCommonTile {
  CategoriesTile({
    required super.name,
    required super.parent,
    required super.children,
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
