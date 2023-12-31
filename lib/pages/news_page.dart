import 'package:cryphive/model/news_model.dart';
import 'package:cryphive/pages/news_detail_page.dart';
import 'package:cryphive/service/news_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<News> newsList = [];

  Future<List<News>> getNewsList(String s) async {
    newsList = await NewsService().getNewsList(s);
    return newsList;
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
          'NEWS',
          style: TextStyle(
            color: Colors.yellowAccent,
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: FutureBuilder(
          future: getNewsList('cryptocurrency'),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot,) {
            if(snapshot.hasData){
              if(newsList.length == 0){
                return const Center(
                  child: Text(
                    'No News Found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              else{
                return ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index){

                    String publishedAt = newsList[index].publishedAt;
                    int indexOfT = publishedAt.indexOf('T');
                    int indexOfZ = publishedAt.indexOf('Z');

                    String datePart = '';
                    String timePart = '';

                    if (indexOfT != -1 && indexOfZ != -1) {
                      datePart = publishedAt.substring(0, indexOfT);
                      timePart = publishedAt.substring(indexOfT + 1, indexOfZ);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return NewsDetailPage(news: newsList[index], index: index,);
                          },),);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                            minVerticalPadding: 5,
                            horizontalTitleGap: 3,
                            leading: Hero(
                              tag: index,
                              child: Container(
                                height: size.height * 0.2,
                                width: size.width * 0.285,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      newsList[index].urlToImage,
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (dynamic exception, StackTrace? stackTrace) => const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.black,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              newsList[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                  'Published: $datePart $timePart',
                                  style: const TextStyle(
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                                Text(
                                  newsList[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
            else if(snapshot.hasError){
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              );
            }
            else{
              return const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(
                    colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                    indicatorType: Indicator.ballClipRotate,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
