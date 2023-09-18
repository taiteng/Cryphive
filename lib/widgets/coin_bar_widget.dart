import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:cryphive/pages/coin_details_page.dart';
import 'package:flutter/material.dart';

class CoinBarWidget extends StatelessWidget {

  var coin;

  CoinBarWidget({super.key, this.coin});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
        vertical: size.height * 0.005,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (contest) => CoinDetailsPage(coin: coin,)));
        },
        child: Container(
          height: size.height * 0.09,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff090a13),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: size.height * 0.04,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        coin.image,
                      ),
                      onBackgroundImageError: (dynamic exception, StackTrace? stackTrace) => const SizedBox(
                        child: Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        coin.id,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        coin.symbol,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: size.height * 0.05,
                    child: Sparkline(
                      data: coin.sparklineIn7D.price,
                      lineWidth: 2.0,
                      lineColor: coin.marketCapChangePercentage24H >= 0
                          ? Colors.green
                          : Colors.red,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7],
                          colors: coin.marketCapChangePercentage24H >= 0
                              ? [Colors.green, Colors.green.shade100]
                              : [Colors.red, Colors.red.shade100]
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$ ${coin.currentPrice}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            coin.priceChange24H.toString().contains('-')
                              ? "-\$${coin.priceChange24H
                                  .toStringAsFixed(2)
                                  .toString()
                                  .replaceAll('-', '')}"
                              : "\$${coin.priceChange24H.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Text(
                            coin.marketCapChangePercentage24H.toStringAsFixed(2) +
                                '%',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: coin.marketCapChangePercentage24H >= 0
                                  ? Colors.green
                                  : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}