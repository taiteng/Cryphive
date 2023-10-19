import 'package:cryphive/model/search_model.dart';
import 'package:cryphive/widgets/coin_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  FocusNode myFocusNode = FocusNode();

  final searchTextController = TextEditingController();

  List<SearchModel>? searchList = [];
  bool isSearchRefreshing = false;

  Future<void> getSearch() async {
    final searchQuery = searchTextController.text.toString();
    if (searchQuery.isEmpty) {
      return;
    }

    final url = 'https://api.coingecko.com/api/v3/search?query=$searchQuery';

    setState(() {
      isSearchRefreshing = true;
    });

    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isSearchRefreshing = false;
    });

    if (response.statusCode == 200) {
      final jsonData = response.body;
      final searchResults = searchModelFromJson(jsonData);
      setState(() {
        searchList = searchResults;
      });
    } else {
      print(response.statusCode);
      // Handle error cases here
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if(searchTextController.text.toString() != '' || searchTextController.text.toString() != null){
      getSearch();
    }

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
          '',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(
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
                              child: TextFormField(
                                onChanged: (value) {
                                  getSearch();
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
                            GestureDetector(
                              onTap: () {
                                getSearch();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: const Color(0xff090a13),
                                  ),
                                ),
                                padding: const EdgeInsets.all(3.0),
                                child: const Icon(Icons.search_rounded),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                height: size.height * 0.5,
                child: isSearchRefreshing
                    ? const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                      colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                      indicatorType: Indicator.ballGridPulse,
                    ),
                  ),
                )
                    : searchList == null || searchList!.isEmpty
                    ? Padding(
                  padding: EdgeInsets.all(size.height * 0.06),
                  child: const Center(
                    child: Text(
                      'No results found.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: searchList!.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CoinSearchWidget(
                      coin: searchList![index],
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
