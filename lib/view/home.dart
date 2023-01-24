part of '/common.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({Key? key}) : super(key: key);

  @override
  _ViewHomeState createState() => _ViewHomeState();
}

class _ViewHomeState extends State<ViewHome> {
  int selectedIndex = 1;

  final List<Widget> bottomNavigationButton = [
    // ViewHome(),
    ViewLotto(),
    ViewConvertText(),
  ];
  //
  void bottomNavigationButtonTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Horoli's olio",
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: COLOR.CHICK_YELLOW,
      ),
      body: SafeArea(
        child: bottomNavigationButton.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_attraction),
            label: 'lotto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'convert',
          ),
        ],
        backgroundColor: COLOR.CHICK_YELLOW,
        // selectedItemColor: ,
        currentIndex: selectedIndex,
        onTap: bottomNavigationButtonTap,
      ),
    );
  }
}
