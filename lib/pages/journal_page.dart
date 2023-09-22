import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/const/custom_clipper.dart';
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

  List<String> _journalIDs = [];

  Future getTradingJournals() async{
    await FirebaseFirestore.instance.collection('TradingJournal').doc(user?.uid.toString()).collection('Journals').get().then(
          (snapshot) => snapshot.docs.forEach((journalID) {
        if (journalID.exists) {
          _journalIDs.add(journalID.reference.id);
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.5,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 3,
                      bottom: 36 + 3,
                    ),
                    height: size.height * 0.2 - 25,
                    decoration: const BoxDecoration(
                      color: Color(0xff151f2c),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Search For Cryptocurrency",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xff090a13),
                              ),
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: const Icon(Icons.search_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            const Divider(color: Colors.grey,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
              ),
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Journals',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xff090a13),
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
                  : _journalIDs == null || _journalIDs!.length == 0
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
                itemCount: _journalIDs!.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return const Text('hi', style: TextStyle(color: Colors.white),);
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
