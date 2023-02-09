part of '/common.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({Key? key}) : super(key: key);

  @override
  _ViewHomeState createState() => _ViewHomeState();
}

class _ViewHomeState extends State<ViewHome>
    with SingleTickerProviderStateMixin {
  late TabController ctrTab;
  late int tabIndex = 0;
  late int selectedIndex = 0;
  final List<String> tabs = TAB.SIDE_TAB;
  // TODO : create widgets
  final List<Widget> testWidgets = [
    ViewDashboard(),
    ViewGuests(),
    ViewMainCategory(),
    ViewSubCategory(),
    ViewQuestion(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Container(
            child: buildSideTabBar(),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  // offset: Offset(5, 10),
                  // spreadRadius: 0,
                  blurRadius: 5,
                )
              ],
            ),
          ).expand(),
          TabBarView(
            controller: ctrTab,
            children: testWidgets,
          ).expand(flex: 5)
        ],
      ),
    );
  }

  Widget buildSideTabBar() {
    return ListView.builder(
      itemCount: tabs.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                selectedIndex == index ? Colors.green : Colors.blue,
          ),
          child: Text(tabs[index]),
          onPressed: () {
            ctrTab.animateTo(tabIndex = index);
            setState(() {
              selectedIndex = index;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ctrTab = TabController(
      initialIndex: tabIndex,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
