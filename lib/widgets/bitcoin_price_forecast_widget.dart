import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.get(Uri.parse('http://192.168.0.113:5000'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      predictions = data['Prediction'];
      predictionList = json.decode(predictions);
      accuracy = data['Accuracy'];

      setState(() {
        isRefreshing = false;
      });
    } else {
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

    return SizedBox(
      height: size.height * 0.4,
      width: size.width * 0.8,
      child: isRefreshing == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffFBC700),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      'Prediction Accuracy: $accuracy',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
