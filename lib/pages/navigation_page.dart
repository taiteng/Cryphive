import 'package:cryphive/pages/community_page.dart';
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
    CommunityPage(),
    JournalPage(),
    SettingsPage(),
  ];

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
