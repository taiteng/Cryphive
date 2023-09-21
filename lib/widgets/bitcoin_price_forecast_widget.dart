import 'package:flutter/material.dart';

class BitcoinPriceForecastWidget extends StatelessWidget {
  const BitcoinPriceForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.015,
    );
  }
}
