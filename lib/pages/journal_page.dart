import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/const/custom_clipper.dart';
import 'package:cryphive/model/trading_journal_model.dart';
import 'package:cryphive/pages/add_journal_page.dart';
import 'package:cryphive/widgets/analysis_of_trades_widget.dart';
import 'package:cryphive/widgets/journal_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool isJournalRefreshing = true;

  List<TradingJournalModel> tradingJournals = [];

  Future getTradingJournals() async {
    tradingJournals = [];

    await FirebaseFirestore.instance
        .collection('TradingJournal')
        .doc(user?.uid.toString())
        .collection('Journals')
        .orderBy('EntryDate', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((journalID) {
            if (journalID.exists) {
              tradingJournals.add(
                TradingJournalModel(
                  action: journalID['Action'],
                  entryDate: journalID['EntryDate'],
                  exitDate: journalID['ExitDate'],
                  entryPrice: journalID['EntryPrice'],
                  exitPrice: journalID['ExitPrice'],
                  feedback: journalID['Feedback'],
                  fees: journalID['Fees'],
                  image: journalID['Image'],
                  journalID: journalID.reference.id,
                  profitAndLoss: journalID['ProfitAndLoss'],
                  riskRewardRatio: journalID['RiskRewardRatio'],
                  stopLoss: journalID['StopLoss'],
                  takeProfit: journalID['TakeProfit'],
                  strategy: journalID['Strategy'],
                  symbol: journalID['Symbol'],
                  timeframe: journalID['Timeframe'],
                ),
              );
            } else {
              print("Ntg to see here");
            }
          }),
        );

    setState(() {
      isJournalRefreshing = false;
    });
  }

  @override
  void initState() {
    getTradingJournals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          'JOURNAL',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.yellowAccent,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddJournalPage(getTradingJournals: getTradingJournals,)));
            },
          ),
        ],
      ),
      body: CarouselSlider(
        slideIndicator: CircularSlideIndicator(
          padding: const EdgeInsets.only(bottom: 10.0),
          currentIndicatorColor: Colors.deepOrangeAccent,
          indicatorBackgroundColor: Colors.grey,
        ),
        slideTransform: const CubeTransform(),
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(10.0), // Adjust the radius as needed
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'Trade Analysis',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff090a13),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                user != null
                    ? SizedBox(
                  child: isJournalRefreshing == true
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffFBC700),
                    ),
                  )
                      : tradingJournals == null || tradingJournals!.length == 0
                      ? Padding(
                    padding: EdgeInsets.all(size.height * 0.06),
                    child: const Center(
                      child: Text(
                        'An error occurred. Please wait and try again later.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                      : AnalysisOfTradesWidget(tradingJournal: tradingJournals,),
                )
                    : const Center(
                  child: Text(
                    'Please login to review your journal analysis',
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(10.0), // Adjust the radius as needed
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'Journals',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff090a13),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                user != null
                    ? SizedBox(
                  child: isJournalRefreshing == true
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffFBC700),
                    ),
                  )
                      : tradingJournals == null || tradingJournals!.length == 0
                      ? Padding(
                    padding: EdgeInsets.all(size.height * 0.06),
                    child: const Center(
                      child: Text(
                        'An error occurred. Please wait and try again later.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: tradingJournals!.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return JournalWidget(
                        tradingJournal: tradingJournals[index],
                        getTradingJournals: getTradingJournals,
                      );
                    },
                  ),
                )
                    : const Center(
                  child: Text(
                    'Please login to review your journals',
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
