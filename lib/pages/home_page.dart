import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/const/custom_clipper.dart';
import 'package:cryphive/model/coin_model.dart';
import 'package:cryphive/model/trend_model.dart';
import 'package:cryphive/model/watchlist_model.dart';
import 'package:cryphive/widgets/bitcoin_price_forecast_widget.dart';
import 'package:cryphive/widgets/coin_bar_widget.dart';
import 'package:cryphive/widgets/coin_card_widget.dart';
import 'package:cryphive/widgets/search_bar_widget.dart';
import 'package:cryphive/widgets/watchlist_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final User? user = FirebaseAuth.instance.currentUser;

  bool isCoinsRefreshing = true;
  List? coinsMarket = [];
  var coinsMarketList;

  Future<List<CoinModel>?> getCoinsMarket() async {
    const url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isCoinsRefreshing = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isCoinsRefreshing = false;
    });

    if (response.statusCode == 200) {
      var x = response.body;
      coinsMarketList = coinModelFromJson(x);
      setState(() {
        coinsMarket = coinsMarketList;
      });
    }
    else {
      print(response.statusCode);
    }
  }

  bool isTrendingRefreshing = true;
  List? trendingCoins = [];
  var trendingList;

  Future<List<CoinModel>?> getTrendingMarket() async {
    const url = 'https://api.coingecko.com/api/v3/search/trending';

    setState(() {
      isTrendingRefreshing = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isTrendingRefreshing = false;
    });

    if (response.statusCode == 200) {
      var x = response.body;
      trendingList = trendModelFromJson(x);
      setState(() {
        trendingCoins = trendingList;
      });
    }
    else {
      print(response.statusCode);
    }
  }

  List<String> _coinIDs = [];

  bool isWatchlistRefreshing = true;
  List? watchlistCoinsMarketList = [];
  var watchlistCoinsMarket;

  Future<List<CoinModel>?> getWatchlistCoinsMarket(String coinID) async {
    String url = 'https://api.coingecko.com/api/v3/coins/$coinID?vs_currency=usd&sparkline=true';

    setState(() {
      isWatchlistRefreshing = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isWatchlistRefreshing = false;
    });

    if (response.statusCode == 200) {
      var x = json.decode(response.body);
      watchlistCoinsMarket = WatchlistModel.fromJson(x);
      setState(() {
        watchlistCoinsMarketList?.add(watchlistCoinsMarket);
      });
    }
    else {
      print(response.statusCode);
    }
  }

  Future getWatchlistCoinIDs() async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).collection('Watchlist').get().then(
            (snapshot) => snapshot.docs.forEach((coinID) {
          if (coinID.exists) {
            _coinIDs.add(coinID.reference.id);

            getWatchlistCoinsMarket(coinID.reference.id);
          } else {
            print("Ntg to see here");
          }
        }),
      );
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    getCoinsMarket();
    getTrendingMarket();

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
        title: const Text(
          'HOME',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: CarouselSlider(
        slideIndicator: CircularSlideIndicator(
          padding: const EdgeInsets.only(bottom: 10.0),
          currentIndicatorColor: Colors.deepOrangeAccent,
          indicatorBackgroundColor: Colors.grey,
        ),
        slideTransform: const CubeTransform(),
        onSlideChanged: (index) {
          watchlistCoinsMarketList?.clear();
          getWatchlistCoinIDs();
        },
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SearchBarWidget(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ClipPath(
                    clipper: CryphiveCustomClipper(),
                    child: Container(
                      height: size.height * 0.75,
                      width: size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey.shade300,
                            spreadRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff090a13),
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'Cryptocurrencies',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            SizedBox(
                              height: size.height * 0.5,
                              child: isCoinsRefreshing == true
                                  ? const Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: LoadingIndicator(
                                    colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                                    indicatorType: Indicator.audioEqualizer,
                                  ),
                                ),
                              )
                                  : coinsMarket == null || coinsMarket!.length == 0
                                  ? Padding(
                                padding: EdgeInsets.all(size.height * 0.06),
                                child: const Center(
                                  child: Text(
                                    'An error occurred. Please wait and try again later.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                                  : ListView.builder(
                                itemCount: coinsMarket!.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CoinBarWidget(
                                    coin: coinsMarket![index],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff090a13),
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'Trending',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            SizedBox(
                              height: size.height * 0.25,
                              width: size.width,
                              child: Padding(
                                padding: EdgeInsets.only(left: size.width * 0.02),
                                child: isTrendingRefreshing == true
                                    ? const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: LoadingIndicator(
                                      colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                                      indicatorType: Indicator.audioEqualizer,
                                    ),
                                  ),
                                )
                                    : trendingCoins == null || trendingCoins!.length == 0
                                    ? Padding(
                                  padding: EdgeInsets.all(size.height * 0.06),
                                  child: const Center(
                                    child: Text(
                                      'An error occurred. Please wait and try again later.',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                                    : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: trendingCoins!.length,
                                  itemBuilder: (context, index) {
                                    return CoinCardWidget(
                                      coin: trendingCoins![index],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff090a13),
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'Bitcoin Price Forecast',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            const BitcoinPriceForecastWidget(),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            color: const Color(0xff151f2c),
            child: ClipPath(
              clipper: CryphiveCustomClipper(),
              child: Container(
                height: size.height * 0.7,
                width: size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey.shade300,
                      spreadRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff090a13),
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Watchlist',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      user != null
                          ? SizedBox(
                        child: isWatchlistRefreshing == true
                            ? const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: LoadingIndicator(
                              colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                              indicatorType: Indicator.audioEqualizer,
                            ),
                          ),
                        )
                            : watchlistCoinsMarketList == null || watchlistCoinsMarketList!.length == 0
                            ? Padding(
                          padding: EdgeInsets.all(size.height * 0.06),
                          child: const Center(
                            child: Text(
                              'An error occurred. Please wait and try again later.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                            : ListView.builder(
                          itemCount: watchlistCoinsMarketList!.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return WatchlistBarWidget(
                              coin: watchlistCoinsMarketList![index],
                            );
                          },
                        ),
                      )
                          : const Center(
                        child: Text(
                          'Please login to review your watchlist',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
