import 'package:cryphive/pages/search_page.dart';
import 'package:flutter/material.dart';

class DisabledSearchBarWidget extends StatefulWidget {
  const DisabledSearchBarWidget({super.key});

  @override
  State<DisabledSearchBarWidget> createState() => _DisabledSearchBarWidgetState();
}

class _DisabledSearchBarWidgetState extends State<DisabledSearchBarWidget> {

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
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return const SearchPage();
                  },),);
                },
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
                    const Icon(Icons.search_rounded),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}