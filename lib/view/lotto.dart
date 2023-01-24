part of '/common.dart';

class ViewLotto extends StatefulWidget {
  const ViewLotto({Key? key}) : super(key: key);

  @override
  _ViewLottoState createState() => _ViewLottoState();
}

class _ViewLottoState extends State<ViewLotto> {
  final Future<LottoInfo> futureLotto = fetchLotto();
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Container().expand(),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                child: const Text('Create LottoNumber'),
                onPressed: () {
                  setState(() {
                    lotto.createNumber();
                  });
                },
              ).expand(),
              const Padding(padding: EdgeInsets.all(5)),
              Container().expand()
            ],
          ).expand(),
          buildListView(lotto.lottoFirst).expand(),
          buildListView(lotto.lottoSecond).expand(),
          buildListView(lotto.lottoThird).expand(),
          buildListView(lotto.lottoFourth).expand(),
          buildListView(lotto.lottoFifth).expand(),
          // buildFutureLotto().expand(),
        ],
      ),
    );
  }

  Widget buildListView(List<int> lottoList) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: lottoList.length,
      itemBuilder: (BuildContext context, int index) {
        Color basicColor = Colors.white;
        if (lottoList[index] <= 10) {
          basicColor = Colors.amber;
        }

        if (10 < lottoList[index] && lottoList[index] <= 20) {
          basicColor = Colors.green;
        }

        if (20 < lottoList[index] && lottoList[index] <= 30) {
          basicColor = Colors.grey;
        }

        if (30 < lottoList[index] && lottoList[index] <= 40) {
          basicColor = const Color(0xFFCBE0EB);
        }

        if (40 < lottoList[index] && lottoList[index] <= 50) {
          basicColor = const Color(0xFFC3A9EE);
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            width: 100,
            decoration: BoxDecoration(
              color: basicColor,
              border: Border.all(),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              '${lottoList[index]}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget buildFutureLotto() {
    print('futureLotto $futureLotto');
    return FutureBuilder<LottoInfo>(
      future: futureLotto,
      builder: (BuildContext context, snapshot) {
        //
        if (snapshot.hasData) {
          return Text('${snapshot.data!.bnusNo}');
          //
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        //
        return Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // futureLotto = fetchLotto();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
