import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BitcoinPriceForecastWidget extends StatefulWidget {
  const BitcoinPriceForecastWidget({super.key});

  @override
  State<BitcoinPriceForecastWidget> createState() => _BitcoinPriceForecastWidgetState();
}

class _BitcoinPriceForecastWidgetState extends State<BitcoinPriceForecastWidget> {

  Future<void> fetchForecastData() async {
    final response = await http.get(Uri.parse('http://192.168.0.111:5000'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    //fetchForecastData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.015,
    );
  }
}
