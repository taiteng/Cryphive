import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {

  String predictedPrice = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchPredictedPrice();
  }

  Future<void> fetchPredictedPrice() async {
    final response = await http.get(Uri.parse('http://your-server-url/predict_bitcoin_price'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        predictedPrice = 'Predicted Bitcoin Price for Tomorrow: \$${data['predicted_price']}';
      });
    } else {
      setState(() {
        predictedPrice = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text(predictedPrice),
      )
    );
  }
}
