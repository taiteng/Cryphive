import 'package:cryphive/pages/coin_details_page.dart';
import 'package:flutter/material.dart';

class CoinCardWidget extends StatelessWidget {

  var coin;

  CoinCardWidget({super.key, this.coin});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.005,
          vertical: size.height * 0.005,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (contest) => CoinDetailsPage(coinID: coin.id,)));
          },
          child: Container(
            width: size.width * 0.285,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                  child: Image.network(
                    coin.large,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  coin.id,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  coin.symbol,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: size.height * 0.01,
                ),
                Text(
                  coin.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: size.height * 0.01,
                ),
                Text(
                  '#${coin.marketCapRank}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.greenAccent,
                  ),
                ),
                SizedBox(
                  width: size.height * 0.01,
                ),
                Text(
                  'Price In Bitcoin: ${coin.priceInBTC}',
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.orangeAccent,
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