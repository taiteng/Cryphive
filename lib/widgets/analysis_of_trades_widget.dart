import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/trading_journal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AnalysisOfTradesWidget extends StatefulWidget {
  final List<TradingJournalModel> tradingJournal;

  const AnalysisOfTradesWidget({
    super.key,
    required this.tradingJournal,
  });

  @override
  State<AnalysisOfTradesWidget> createState() => _AnalysisOfTradesWidgetState();
}

class _AnalysisOfTradesWidgetState extends State<AnalysisOfTradesWidget> {

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _user = FirebaseFirestore.instance.collection('Users');

  int totalTrades = 0;
  int numberOfWinningTrades = 0;
  int numberOfLosingTrades = 0;
  int numOfProfit = 0;
  int numOfLoss = 0;
  num totalProfit = 0;
  num totalLoss = 0;
  num averageProfit = 0;
  num averageLoss = 0;
  num averageRiskRewardRatio = 0;
  num totalRRR = 0;
  num highestRiskRewardRatio = 0;
  Map<int, double> chartData = {};
  List<FlSpot> spots = [];
  List<double> tJournals = [];

  void getAnalysis(){
    totalTrades = widget.tradingJournal.length;

    for (TradingJournalModel journal in widget.tradingJournal) {
      if (journal.exitPrice > journal.entryPrice) {
        numberOfWinningTrades++;
      }
      else{
        numberOfLosingTrades++;
      }
    }

    for (TradingJournalModel journal in widget.tradingJournal) {
      if(journal.profitAndLoss > 0){
        numOfProfit++;
        totalProfit += journal.profitAndLoss;
      }
      else{
        numOfLoss++;
        totalLoss += journal.profitAndLoss;
      }
    }

    averageProfit = totalProfit/numOfProfit;
    averageLoss = totalLoss/numOfLoss;

    for (TradingJournalModel journal in widget.tradingJournal) {
      totalRRR += journal.riskRewardRatio;
    }

    averageRiskRewardRatio = totalRRR/totalTrades;

    for (TradingJournalModel journal in widget.tradingJournal) {
      if (journal.riskRewardRatio > highestRiskRewardRatio) {
        highestRiskRewardRatio = journal.riskRewardRatio;
      }
    }

    for (int i = totalTrades - 1; i >= 0; i--) {
      tJournals.add(widget.tradingJournal[i].profitAndLoss.toDouble());
    }

    for (int i = 0; i < totalTrades; i++) {
      spots.add(FlSpot(i.toDouble(), tJournals[i]));
    }
  }

  @override
  void initState() {
    getAnalysis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: _user.doc(user?.uid.toString()).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot){
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              else if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Username does not exist");
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                num endingBalance = data['Capital'];

                for (TradingJournalModel journal in widget.tradingJournal) {
                  endingBalance += journal.profitAndLoss;
                }

                num returnOfInvestment = ((endingBalance - data['Capital']) / data['Capital']) * 100 ;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.3,
                      decoration: const BoxDecoration(
                        color: Color(0xff21250f),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Initial Balance',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '\$${data['Capital'].toString()}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.3,
                      decoration: const BoxDecoration(
                        color: Color(0xff21250f),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ending Balance',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '\$${endingBalance.toString()}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.3,
                      decoration: const BoxDecoration(
                        color: Color(0xff21250f),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ROI',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${returnOfInvestment.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                      colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                      indicatorType: Indicator.ballZigZag,
                    ),
                  ),
                );
              }
            }
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          height: size.height * 0.2,
          width: size.width * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xff21250f),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Total\nTrades:\n${totalTrades.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  PieChart(
                    swapAnimationDuration: const Duration(milliseconds: 750,),
                    swapAnimationCurve: Curves.easeInOutQuint,
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: numberOfWinningTrades.toDouble(),
                          color: Colors.lightBlue,
                          title: 'Win: ${numberOfWinningTrades.toString()}',
                        ),
                        PieChartSectionData(
                          value: numberOfLosingTrades.toDouble(),
                          color: Colors.red,
                          title: 'Lose: ${numberOfLosingTrades.toString()}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Profit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      totalProfit.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Average Profit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      averageProfit.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Loss',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      totalLoss.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Average Loss',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      averageLoss.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Highest Risk Reward Ratio',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      highestRiskRewardRatio.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Container(
              height: size.height * 0.1,
              width: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff21250f),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Average Risk Reward Ratio',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      averageRiskRewardRatio.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          height: size.height * 0.25,
          width: size.width * 0.9,
          decoration: const BoxDecoration(
            color: Color(0xff21250f),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  'Profit & Loss Line Chart',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.18,
                width: size.width * 0.85,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50,)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false, reservedSize: 20, interval: 1,)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.lightBlueAccent,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: const LineTouchData(enabled: true, touchTooltipData: LineTouchTooltipData()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
      ],
    );
  }
}
