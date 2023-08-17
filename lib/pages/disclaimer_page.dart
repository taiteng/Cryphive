import 'package:cryphive/pages/register_page.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151f2c),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
        title: const Text(
          'Disclaimer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'The cryptocurrencies that are likely to appear on the Trendings list and Price Forecasts are cryptocurrencies that experience the most trading volume, have significant price movement or the highest liquidity in the market. It is essential to know that cryptocurrencies that are being listed on the Trending list and Price Forecast does not imply endorsement or investment advice by Cryphive, and traders must always conduct their research and analysis before deciding which cryptocurrency to trade.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
