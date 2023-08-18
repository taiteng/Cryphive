import 'dart:convert';
import 'package:cryphive/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static String BASE_URL = 'https://newsapi.org/v2/everything?q=';

  getNewsList(String query) async {
    var response = await http.get(Uri.parse(BASE_URL + query + '&apiKey=d387b58ae8254db685545577fb74d7fe'));

    if(response.statusCode == 200){
      List<News> newsList;
      var finalResult = json.decode(response.body);
      newsList = (finalResult['articles'] as List).map((e) => News.fromJson(e)).toList();

      return newsList;
    }
    else{
      print('Error Occurred');
    }
  }
}