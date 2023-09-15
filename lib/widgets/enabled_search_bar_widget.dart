import 'package:cryphive/pages/search_page.dart';
import 'package:flutter/material.dart';

class EnabledSearchBarWidget extends StatefulWidget {
  const EnabledSearchBarWidget({super.key});

  @override
  State<EnabledSearchBarWidget> createState() => _EnabledSearchBarWidgetState();
}

class _EnabledSearchBarWidgetState extends State<EnabledSearchBarWidget> {

  final searchTextController = TextEditingController();

  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.1,
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
                      onChanged: (value) {
                        print(value);
                      },
                      controller: searchTextController,
                      autofocus: true,
                      focusNode: myFocusNode,
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
                  const Icon(Icons.search_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}