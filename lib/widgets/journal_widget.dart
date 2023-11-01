import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/trading_journal_model.dart';
import 'package:cryphive/pages/edit_journal_page.dart';
import 'package:cryphive/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalWidget extends StatefulWidget {

  final TradingJournalModel tradingJournal;

  const JournalWidget({
    super.key,
    required this.tradingJournal,
  });

  @override
  State<JournalWidget> createState() => _JournalWidgetState();
}

class _JournalWidgetState extends State<JournalWidget> {

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteFromFirebase() async{
    try{
      final journalRef = FirebaseFirestore.instance
          .collection("TradingJournal")
          .doc(user?.uid.toString())
          .collection("Journals")
          .doc(widget.tradingJournal.journalID);

      await journalRef.delete();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 3,)));
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: size.height * 0.3,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                  child: Text(
                    widget.tradingJournal.journalID.toString(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Symbol: ${widget.tradingJournal.symbol}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Action: ${widget.tradingJournal.action}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Strategy: ${widget.tradingJournal.strategy}',
                        ),
                        Text(
                          'Timeframe: ${widget.tradingJournal.timeframe}',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entry Price: ${widget.tradingJournal.entryPrice.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Exit Price: ${widget.tradingJournal.exitPrice.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Stop Loss: ${widget.tradingJournal.stopLoss.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Take Profit: ${widget.tradingJournal.takeProfit.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profit/Loss: ${widget.tradingJournal.profitAndLoss.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Risk Reward Ratio: ${widget.tradingJournal.riskRewardRatio.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Feedback: ${widget.tradingJournal.feedback}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Fees: ${widget.tradingJournal.fees.toString()}',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entry Date: ${widget.tradingJournal.entryDate.toDate()}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Exit Date: ${widget.tradingJournal.exitDate.toDate()}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if(widget.tradingJournal.hasImage){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Journal Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            content: SizedBox(
                              height: size.height * 0.275,
                              width:  size.width * 0.9,
                              child: Image.network(
                                widget.tradingJournal.image.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                                  return const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        '😢 Something Went Wrong',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.indigo,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0,),
                      child: Text(
                        'Click to view image',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => EditJournalPage(tradingJournal: widget.tradingJournal,),),);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.teal,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0,),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Are you sure you want to delete journal ${widget.tradingJournal.journalID}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              onPressed: () {
                                deleteFromFirebase();
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(index: 3,)));
                                });
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0,),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnack(
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
