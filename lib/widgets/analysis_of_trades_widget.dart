import 'package:cryphive/model/trading_journal_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
  num returnOfInvestment = 0;
  num totalInvestment = 0;
  num profit = 0;
  Map<int, double> chartData = {};
  List<FlSpot> spots = [];

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

    for (TradingJournalModel journal in widget.tradingJournal) {
      profit += journal.exitPrice - journal.entryPrice;
    }

    for (TradingJournalModel journal in widget.tradingJournal) {
      totalInvestment += journal.entryPrice;
    }

    returnOfInvestment = (profit/totalInvestment) * 100;

    for (int i = 0; i < totalTrades; i++) {
      spots.add(FlSpot(i.toDouble(), widget.tradingJournal[i].profitAndLoss.toDouble()));
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
                          title: 'Loss: ${numberOfLosingTrades.toString()}',
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
                      'Return Of Investment',
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
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50,)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 20, interval: 1,)),
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
      ],
    );
  }
}
