import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class BitcoinPriceForecastWidget extends StatefulWidget {
  const BitcoinPriceForecastWidget({super.key});

  @override
  State<BitcoinPriceForecastWidget> createState() =>
      _BitcoinPriceForecastWidgetState();
}

class _BitcoinPriceForecastWidgetState
    extends State<BitcoinPriceForecastWidget> {
  DateTime currentDate = DateTime.now();

  bool isRefreshing = true;
  bool isError = false;

  String predictions = "";
  List<dynamic> predictionList = [];

  String accuracy = "";

  String changeDateFormat(DateTime date) {
    return '${date.year}-${changeTwoDigits(date.month)}-${changeTwoDigits(date.day)}';
  }

  String changeTwoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  Future<void> fetchForecastData() async {
    //Start the LSTM model and change the URL based on the IP server given
    final response = await http.get(Uri.parse('http://192.168.0.103:5000'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      predictions = data['Prediction'];
      predictionList = json.decode(predictions);
      accuracy = data['Accuracy'];

      final List<DateTime> dates = List.generate(30, (index) {
        return DateTime.now().add(Duration(days: index + 1));
      });

      setState(() {
        isRefreshing = false;
      });
    } else {
      setState(() {
        isRefreshing = false;
        isError = true;
      });
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchForecastData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isRefreshing == true
        ? SizedBox(
      height: size.height * 0.3,
      width: size.width * 0.8,
          child: const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: LoadingIndicator(
                colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                indicatorType: Indicator.audioEqualizer,
              ),
            ),
            Text(
              'Model is Running, Please Wait...',
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ],
      ),
    ),
        )
        : isError ? SizedBox(
      height: size.height * 0.3,
      width: size.width * 0.8,
          child: const Center(
      child: Text(
          'An Error Occured. Please Try Again Later.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
      ),
    ),
        ) : SizedBox(
      height: size.height * 0.85,
      width: size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                'Forecast Accuracy: $accuracy',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: size.width * 0.005,
                )),
            height: size.height * 0.3,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(
                        changeDateFormat(currentDate.add(Duration(days: index + 1))),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        color: Colors.grey,
                      ),
                      child: Text(
                        '${predictionList[index]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Forecast for the next 30 days',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.325,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color(0xff42501c),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50,)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(predictionList.length, (index) {
                        return FlSpot(index.toDouble(), predictionList[index].toDouble());
                      }),
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
