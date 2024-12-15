import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app_api/model/new_model.dart';

String apiKey = "";

class NewsApi {
  List<NewsModel> dataStore = [];

  Future<void> getNews(String query) async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&language=en&apiKey=$apiKey");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == 'ok') {
      dataStore = []; // Clear previous data
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );
          dataStore.add(newsModel);
        }
      });
    }
  }
}
