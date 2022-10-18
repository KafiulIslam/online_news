import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../model/article_model.dart';
import '../api/news_api.dart';
import 'category_state.dart';

class ArticleState extends GetxController{


  final TextEditingController controller = TextEditingController();
    String _searchController = 'us';
    String get searchController => _searchController;
    changeLocation ( String value){
  _searchController = value;
  update();
  }


  final _numberOfArticlePerRequest = 5;
  final PagingController<int, ArticleModel> pagingController =
  PagingController(firstPageKey: 1);

  Future<void> fetchPage(int pageKey,String categoryName) async {
    try {
      final response = await getTopHeadLines(
          searchController,
          categoryName
      );
      late List<ArticleModel> relatedArticles = [];
      response['data']['articles'].forEach((element) {
        String author = element['author'] ?? 'Unknown';
        String title = element['title'] ?? '';
        String description = element['description'] ?? '';
        String url = element['url'] ?? '';
        String urlToImage = element['urlToImage'] ?? '';
        String content = element['content'] ?? '';
        relatedArticles.add(ArticleModel(
            author: author,
            title: title,
            description: description,
            url: url,
            urlToImage: urlToImage,
            content: content));
      });

      final isLastPage = relatedArticles.length < _numberOfArticlePerRequest;

      if (isLastPage) {
        pagingController.appendLastPage(relatedArticles);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(relatedArticles, nextPageKey);
      }
    } catch (e) {
      print("error --> $e");
      pagingController.error = e;
    }
  }

}