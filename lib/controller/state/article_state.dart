import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:online_news_app/views/widgets/custom_snack.dart';
import '../../model/article_model.dart';
import '../api/news_api.dart';

class ArticleState extends GetxController{

  final TextEditingController controller = TextEditingController();
    String _searchController = 'us';
    String get searchController => _searchController;
    changeLocation ( String value){
  _searchController = value;
  update();
  }


  final _numberOfArticlePerRequest = 5;
  String? _currentCategoryName = 'general';
  
  late final PagingController<int, ArticleModel> pagingController;
  
  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController<int, ArticleModel>(
      getNextPageKey: (state) {
        final items = state.items ?? [];
        // If we have fewer items than expected, we're on the last page
        if (items.length < _numberOfArticlePerRequest) {
          return null;
        }
        // Calculate next page key: start from 1, increment by 1 for each page
        // Since we fetch pages sequentially starting from 1
        return (items.length ~/ _numberOfArticlePerRequest) + 1;
      },
      fetchPage: (int pageKey) async {
        try {
          final response = await getTopHeadLines(
              searchController,
              _currentCategoryName ?? 'general'
          );
          List<ArticleModel> relatedArticles = [];
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
          return relatedArticles;
        } catch (e) {
          CustomSnack.warningSnack(e.toString());
          return <ArticleModel>[];
        }
      },
    );
  }
  
  @override
  void onClose() {
    pagingController.dispose();
    controller.dispose();
    super.onClose();
  }

  Future<void> fetchPage(int pageKey, String categoryName) async {
    _currentCategoryName = categoryName;
    pagingController.refresh();
  }

}
