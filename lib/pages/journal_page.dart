import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/const/custom_clipper.dart';
import 'package:cryphive/model/trading_journal_model.dart';
import 'package:cryphive/pages/add_journal_page.dart';
import 'package:cryphive/widgets/analysis_of_trades_widget.dart';
import 'package:cryphive/widgets/journal_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:loading_indicator/loading_indicator.dart';

class JournalPage extends StatefulWidget {

  const JournalPage({
    super.key,
  });

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {

  final User? user = FirebaseAuth.instance.currentUser;

  bool isJournalRefreshing = true;

  List<TradingJournalModel> tradingJournals = [];

  Future getTradingJournals() async {
    try{
      tradingJournals = [];

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid.toString())
          .collection('TradingJournals')
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
                image: journalID['ImageURL'],
                journalID: journalID.reference.id,
                profitAndLoss: journalID['ProfitAndLoss'],
                riskRewardRatio: journalID['RiskRewardRatio'],
                stopLoss: journalID['StopLoss'],
                takeProfit: journalID['TakeProfit'],
                strategy: journalID['Strategy'],
                symbol: journalID['Symbol'],
                timeframe: journalID['Timeframe'],
                hasImage: journalID['HasImage'],
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
    } catch (error) {
      print(error.toString());
    }
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
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.yellowAccent,
              size: 30,
            ),
            onPressed: () {
              if(user != null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddJournalPage()));
              }
              else{
                buildSnackError(
                  'Please Login',
                  context,
                  size,
                );
              }
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
        onSlideChanged: (index) {
          tradingJournals?.clear();
          getTradingJournals();
        },
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
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(
                        colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                        indicatorType: Indicator.ballRotateChase,
                      ),
                    ),
                  )
                      : tradingJournals == null || tradingJournals!.length == 0
                      ? Padding(
                    padding: EdgeInsets.all(size.height * 0.06),
                    child: const Center(
                      child: Text(
                        'No Journals Found.',
                        style: TextStyle(fontSize: 18, color: Colors.white,),
                      ),
                    ),
                  )
                      : AnalysisOfTradesWidget(tradingJournal: tradingJournals,),
                )
                    : const Center(
                  child: Text(
                    'Please login to review your journal analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
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
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: LoadingIndicator(
                        colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                        indicatorType: Indicator.ballRotateChase,
                      ),
                    ),
                  )
                      : tradingJournals == null || tradingJournals!.length == 0
                      ? Padding(
                    padding: EdgeInsets.all(size.height * 0.06),
                    child: const Center(
                      child: Text(
                        'No Journals Found.',
                        style: TextStyle(fontSize: 18, color: Colors.white,),
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
                      );
                    },
                  ),
                )
                    : const Center(
                  child: Text(
                    'Please login to review your journals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }
}
