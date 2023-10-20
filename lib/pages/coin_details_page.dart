import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/chart_model.dart';
import 'package:cryphive/model/coin_details_model.dart';
import 'package:cryphive/widgets/add_alert_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinDetailsPage extends StatefulWidget {
  var coinID;

  CoinDetailsPage({
    super.key,
    this.coinID,
  });

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  late TrackballBehavior trackballBehavior;

  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  bool isWatchlist = false;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> checkIsWatchlist() async {
    final coinIDSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid.toString())
        .collection('Watchlist')
        .doc(widget.coinID)
        .get();

    if (mounted) {
      setState(() {
        isWatchlist = coinIDSnapshot.exists;
      });
    }
  }

  Future<void> editWatchlist() async {
    final favouriteRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid.toString())
        .collection("Watchlist")
        .doc(widget.coinID);

    if (isWatchlist) {
      await favouriteRef.delete();
    } else {
      await favouriteRef.set({
        'coinID': widget.coinID,
      });
    }

    setState(() {
      isWatchlist = !isWatchlist;
    });
  }

  List<ChartModel>? itemChart;
  bool isRefresh = true;

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

  Future<void> getChart() async {
    String url =
        'https://api.coingecko.com/api/v3/coins/${widget.coinID}/ohlc?vs_currency=usd&days=$days';

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

  bool isDetailsRefreshing = true;
  var coinDetails, detailsList;

  Future<List<CoinDetailsModel>?> getCoinDetails() async {
    String url =
        'https://api.coingecko.com/api/v3/coins/${widget.coinID}?vs_currency=usd';

    setState(() {
      isDetailsRefreshing = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isDetailsRefreshing = false;
    });

    if (response.statusCode == 200) {
      var x = json.decode(response.body);
      detailsList = CoinDetailsModel.fromJson(x);
      setState(() {
        coinDetails = detailsList;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    checkIsWatchlist();
    getChart();
    getCoinDetails();
    trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
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
        title: isDetailsRefreshing == true || coinDetails == null
            ? const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.yellowAccent,
                ),
              )
            : Text(
                coinDetails.name,
                style: const TextStyle(
                  color: Colors.yellowAccent,
                ),
              ),
      ),
      body: isDetailsRefreshing == true
          ? const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: LoadingIndicator(
            colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
            indicatorType: Indicator.lineScale,
          ),
        ),
      )
          : coinDetails == null
              ? Padding(
                  padding: EdgeInsets.all(size.height * 0.06),
                  child: const Center(
                    child: Text(
                      'An error occurred. Please wait and try again later.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                left: 3,
                                right: 3,
                                bottom: 36 + 3,
                              ),
                              height: size.height * 0.2 - 25,
                              decoration: const BoxDecoration(
                                color: Color(0xff151f2c),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(36),
                                  bottomRight: Radius.circular(36),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.08,
                                          child: AspectRatio(
                                            aspectRatio: 1.0,
                                            child: Image.network(
                                              coinDetails.image.large,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                      size: 50,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.03,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              coinDetails.id,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Text(
                                              coinDetails.symbol,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${coinDetails.marketData.currentPrice}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Text(
                                          '${coinDetails.marketData.marketCapChangePercentage24H}%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: coinDetails.marketData
                                                        .marketCapChangePercentage24H >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  '\$${coinDetails.marketData.low24h}',
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
                                  '\$${coinDetails.marketData.high24h}',
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
                                  '\$${coinDetails.marketData.totalVolume}M',
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
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: LoadingIndicator(
                              colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                              indicatorType: Indicator.lineScale,
                            ),
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
                                    backgroundColor: Colors.white,
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
                                          lowValueMapper:
                                              (ChartModel sales, _) =>
                                                  sales.low,
                                          highValueMapper:
                                              (ChartModel sales, _) =>
                                                  sales.high,
                                          openValueMapper:
                                              (ChartModel sales, _) =>
                                                  sales.open,
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
                      SizedBox(
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
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                              ),
                              child: const Text(
                                'Description',
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
                              child: HtmlWidget(
                                coinDetails.description.en,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                onErrorBuilder: (context, element, error) =>
                                    Text(
                                  '$element error: $error',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                onLoadingBuilder:
                                    (context, element, loadingProgress) =>
                                    const Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: LoadingIndicator(
                                          colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                                          indicatorType: Indicator.lineScale,
                                        ),
                                      ),
                                    ),
                                onTapUrl: (url) async =>
                                    await launchUrl(Uri.parse(url)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.085,
                        width: size.width,
                        // color: Colors.amber,
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () {
                                  if (user != null) {
                                    editWatchlist();

                                    if (isWatchlist) {
                                      buildSnack(
                                        'Removed from Watchlist',
                                        context,
                                        size,
                                      );
                                    } else {
                                      buildSnack(
                                        'Added to Watchlist',
                                        context,
                                        size,
                                      );
                                    }
                                  } else {
                                    buildSnack(
                                      'Please Login',
                                      context,
                                      size,
                                    );
                                  }
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
                                      isWatchlist
                                          ? Icon(
                                              Icons.watch_later,
                                              size: size.height * 0.02,
                                            )
                                          : Icon(
                                              Icons.watch_later_outlined,
                                              size: size.height * 0.02,
                                            ),
                                      isWatchlist
                                          ? const Text(
                                              'Added to Watchlist',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )
                                          : const Text(
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddAlertWidget(
                                        symbol: coinDetails.symbol,
                                        id: coinDetails.id,
                                      );
                                    },
                                  );
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
                      ),
                    ],
                  ),
                ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnack(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
