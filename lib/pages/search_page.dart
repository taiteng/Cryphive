import 'package:cryphive/widgets/enabled_search_bar_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final tag = 'search';

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff090a13),
      appBar: AppBar(
        elevation: 0.00,
        titleSpacing: 00.0,
        toolbarHeight: 35,
        toolbarOpacity: 0.8,
        backgroundColor: const Color(0xff151f2c),
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              EnabledSearchBarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
