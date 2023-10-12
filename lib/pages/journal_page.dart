import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/const/custom_clipper.dart';
import 'package:cryphive/model/trading_journal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    await FirebaseFirestore.instance
        .collection('TradingJournal')
        .doc(user?.uid.toString())
        .collection('Journals')
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
                  riskOfReward: journalID['RiskOfReward'],
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
            ),
            onPressed: () {

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: size.height * 0.05,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: size.height * 0.1,
                      decoration: const BoxDecoration(
                        color: Color(0xff151f2c),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                      ),
                      child: const Text(
                        'Trade Analysis',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
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
                                  return const Text(
                                    'hi',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                  )
                : const Center(
                    child: Text(
                      'Please login to review your watchlist',
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
