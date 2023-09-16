import 'dart:convert';
import 'package:cryphive/model/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class CoinDetailsPage extends StatefulWidget {
  var coin;

  CoinDetailsPage({
    super.key,
    this.coin,
  });

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  late TrackballBehavior trackballBehavior;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: Text(
          widget.coin.name,
          style: const TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        child: Image.network(
                          widget.coin.image,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.coin.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            widget.coin.symbol,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${widget.coin.currentPrice}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        '${widget.coin.marketCapChangePercentage24H}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: widget.coin.marketCapChangePercentage24H >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Low',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              '\$${widget.coin.low24H}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'High',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              '\$${widget.coin.high24H}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Vol',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Text(
                              '\$${widget.coin.totalVolume}M',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width,
                    // color: Colors.amber,
                    child: isRefresh == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFBC700),
                            ),
                          )
                        : itemChart == null
                            ? Padding(
                                padding: EdgeInsets.all(size.height * 0.06),
                                child: const Center(
                                  child: Text(
                                    'An error occurred. Please wait and try again later.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : SfCartesianChart(
                                trackballBehavior: trackballBehavior,
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  zoomMode: ZoomMode.x,
                                ),
                                series: <CandleSeries>[
                                  CandleSeries<ChartModel, int>(
                                      enableSolidCandles: true,
                                      enableTooltip: true,
                                      bullColor: Colors.green,
                                      bearColor: Colors.red,
                                      dataSource: itemChart!,
                                      xValueMapper: (ChartModel sales, _) =>
                                          sales.time,
                                      lowValueMapper: (ChartModel sales, _) =>
                                          sales.low,
                                      highValueMapper:
                                          (ChartModel sales, _) => sales.high,
                                      openValueMapper:
                                          (ChartModel sales, _) => sales.open,
                                      closeValueMapper:
                                          (ChartModel sales, _) =>
                                              sales.close,
                                      animationDuration: 55),
                                ],
                              ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Center(
                    child: SizedBox(
                      height: size.height * 0.03,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  textBool = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  textBool[index] = true;
                                });
                                setDays(text[index]);
                                getChart();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: textBool[index] == true
                                      ? Colors.orangeAccent
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  text[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06,
                          ),
                          child: const Text(
                            'News',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06,
                            vertical: size.height * 0.01,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.25,
                                child: const Icon(
                                  Icons.people,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
              width: size.width,
              // color: Colors.amber,
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.012,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffFBC700),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: size.height * 0.02,
                                ),
                                const Text(
                                  'Add to Watchlist',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.012,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.notification_add_rounded,
                              color: Colors.grey,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [true, false, false, false, false, false];

  int days = 1;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url =
        '${'https://api.coingecko.com/api/v3/coins/' + widget.coin.id}/ohlc?vs_currency=usd&days=$days';

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
