import 'package:flutter/material.dart';
import 'package:new_app_api/Screen/news_detail.dart';
import 'package:new_app_api/Services/services.dart';
import '../model/new_model.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String query = "philippine";
  @override
  void initState() {
    super.initState();
    fetchNews(query);
  }

  Future<void> fetchNews(String searchQuery) async {
    setState(() {
      isLoading = true;
    });

    NewsApi newsApi = NewsApi();
    await newsApi.getNews(searchQuery);
    setState(() {
      articles = newsApi.dataStore;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JC News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            tooltip: "Home",
            onPressed: () {
              _searchController.clear();
              fetchNews("philippine");
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search news...",
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchNews(value);
                }
              },
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetail(newsModel: article),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            article.urlToImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            article.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                          color: Colors.white24,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _searchController.clear();
          fetchNews("philippine");
        },
        tooltip: "Home",
        backgroundColor: Colors.white,
        child: const Icon(Icons.home, color: Colors.black),
      ),
    );
  }
}
