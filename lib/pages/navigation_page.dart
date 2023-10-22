import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryphive/model/chart_model.dart';
import 'package:cryphive/pages/community_page.dart';
import 'package:cryphive/pages/home_page.dart';
import 'package:cryphive/pages/journal_page.dart';
import 'package:cryphive/pages/news_page.dart';
import 'package:cryphive/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NavigationPage extends StatefulWidget {

  int index;

  NavigationPage({
    super.key,
    required this.index,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  var currentIndex;

  final screens = const [
    HomePage(),
    NewsPage(),
    CommunityPage(),
    JournalPage(),
    SettingsPage(),
  ];

  final User? user = FirebaseAuth.instance.currentUser;

  List<String> _alertIDs = [];

  int timeZoneOffsetHours = 8;
  int count = 0;

  List<String> notificationID = ['demo'];
  List<ChartModel>? itemChart;
  ChartModel? alertChartModel;

  Future<void> _scheduleNotification() async {
    try{
      if(user != null){
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        // Android-specific notification details
        const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '666',
          'Cryphive Alerts',
          icon: '@mipmap/ic_launcher',
          channelDescription: 'channel description',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        );

        // Notification details
        const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

        await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).collection('Notifications').get().then(
              (snapshot) => snapshot.docs.forEach((alertID) async {
            if (alertID.exists) {
              _alertIDs.add(alertID.reference.id);

              if(alertID['Initialized'] == false){
                Timestamp firebaseTimestamp = alertID['InputDate'];
                DateTime dateTime = firebaseTimestamp.toDate();
                int unixTimestamp = dateTime.toUtc().millisecondsSinceEpoch + (timeZoneOffsetHours * 3600000);
                int currentUnixTimestamp = (DateTime.now().toUtc().millisecondsSinceEpoch) + (timeZoneOffsetHours * 3600000);
                int durationMilliseconds = (currentUnixTimestamp - unixTimestamp).abs();
                int durationDays = (durationMilliseconds / (24 * 60 * 60 * 1000)).floor();

                if(durationDays == 0){
                  durationDays = 1;
                }
                else if(durationDays > 1 && durationDays <= 7){
                  durationDays = 7;
                }
                else if(durationDays > 7 && durationDays <= 30){
                  durationDays = 30;
                }
                else if(durationDays > 30 && durationDays <= 90){
                  durationDays = 90;
                }
                else if(durationDays > 90 && durationDays <= 180){
                  durationDays = 180;
                }
                else if(durationDays > 180 && durationDays <= 365){
                  durationDays = 365;
                }
                else{
                  durationDays = 365;
                }

                await getOpenHighLowClose(alertID['SymbolID'], durationDays);

                if(itemChart != null){
                  for (ChartModel chartModel in itemChart!) {
                    if (chartModel.time >= unixTimestamp) {
                      alertChartModel = chartModel;

                      if(alertChartModel != null){
                        if((alertChartModel!.high! >= alertID['Price'] && (alertChartModel!.low! <= alertID['Price'] || alertChartModel!.open! <= alertID['Price'])) ||
                            (alertChartModel!.close! >= alertID['Price'] && (alertChartModel!.open! <= alertID['Price'] || alertChartModel!.low! <= alertID['Price']))) {
                          notificationID.forEach((String id) async {

                            if(id == alertID.reference.id){

                            }
                            else{
                              await flutterLocalNotificationsPlugin.show(
                                count,
                                alertID['Title'],
                                '${alertID["Symbol"]} ${alertID["Condition"]} ${alertID["Price"]}',
                                platformChannelSpecifics,
                                payload: 'Testing',
                              );

                              notificationID.add(alertID.reference.id);

                              count++;

                              await FirebaseFirestore.instance.collection('Users').doc(user?.uid.toString()).collection('Notifications').doc(alertID.reference.id).set({
                                'Initialized': true,
                                'Title': alertID['Title'],
                                'Description': alertID['Description'],
                                'Symbol': alertID['Symbol'],
                                'SymbolID': alertID['SymbolID'],
                                'Condition': alertID['Condition'],
                                'Price': alertID['Price'],
                                'InputDate': alertID['InputDate'],
                              });
                            }
                          });
                        }
                      }
                    }
                  }
                }
              }
            } else {
              print("Ntg to see here");
            }
          }),
        );
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> getOpenHighLowClose(String symbolID, int days) async {
    String url = 'https://api.coingecko.com/api/v3/coins/$symbolID/ohlc?vs_currency=usd&days=$days';

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList = x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    currentIndex = widget.index;
    _scheduleNotification();
    count = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          const Align(alignment: Alignment.bottomCenter,),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: size.width * .165,
        child: BottomNavigationBar(
          elevation: 10,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          backgroundColor: const Color(0xff151f2c),
          selectedItemColor: Colors.deepOrange,
          selectedIconTheme: const IconThemeData(size: 33,),
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/cryphive_logo_nobg.png'),
              ),
              label: 'Cryphive',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/h_icon.png'),
              ),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/i_icon.png'),
              ),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/v_icon.png'),
              ),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/e_icon.png'),
              ),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
