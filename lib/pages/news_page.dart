import 'package:cryphive/model/news_model.dart';
import 'package:cryphive/pages/news_detail_page.dart';
import 'package:cryphive/service/news_service.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<News> newsList = [];

  getNewsList(String s) async {
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return NewsDetailPage(news: newsList[index], index: index,);
                      },),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Hero(
                          tag: index,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.135,
                            width: MediaQuery.of(context).size.height * 0.165,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  newsList[index].urlToImage,
                                ),
                                fit: BoxFit.cover,
                                onError: (context, error) => const SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.white,
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
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          newsList[index].description,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.grey,
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
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
