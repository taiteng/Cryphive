import 'package:cryphive/pages/forum_page.dart';
import 'package:cryphive/pages/home_page.dart';
import 'package:cryphive/pages/journal_page.dart';
import 'package:cryphive/pages/news_page.dart';
import 'package:cryphive/pages/settings_page.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  var currentIndex = 0;

  final screens = const [
    HomePage(),
    NewsPage(),
    ForumPage(),
    JournalPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff151f2c),
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: size.width * .165,
        margin: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            iconSize: 28,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.deepOrange,
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum_rounded),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
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
      ),
    );
  }
}
