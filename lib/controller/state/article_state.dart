import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../model/article_model.dart';
import '../api/news_api.dart';
import 'package:online_news_app/views/widgets/custom_snack.dart';

class ArticleState extends GetxController {
  final TextEditingController controller = TextEditingController();

  // Country & category
  String _country = 'us';
  String get searchController => _country;
  String _category = 'general';

  // Page size per request
  static const int _pageSize = 20;

  // Cache (we fetch once, then slice into pages)
  List<ArticleModel> _cache = [];
  String? _cachedCountry;
  String? _cachedCategory;

  // v5 controller (uncontrolled mode)
  late final PagingController<int, ArticleModel> pagingController;

  @override
  void onInit() {
    super.onInit();

    pagingController = PagingController<int, ArticleModel>(
      getNextPageKey: (state) {
        final items = state.items ?? [];
        print('🔍 getNextPageKey called: items.length=${items.length}, _cache.length=${_cache.length}');
        
        // If cache is empty, return 1 to trigger first fetch
        if (_cache.isEmpty) {
          print('📥 Cache empty, returning page 1');
          return 1;
        }
        
        // If we have fewer items shown than cached, there are more pages
        if (items.length < _cache.length) {
          // Calculate the next page number based on current items
          final currentPage = (items.length / _pageSize).ceil();
          final nextPage = currentPage + 1;
          print('➡️ More pages available: currentPage=$currentPage, returning nextPage=$nextPage');
          return nextPage;
        }
        
        // No more pages
        print('✅ All pages loaded: items.length=${items.length}, _cache.length=${_cache.length}');
        return null;
      },
      fetchPage: (int pageKey) async {
        try {
          // If filters changed or cache empty → refetch full list
          final needsRefresh =
              _cachedCountry != _country || _cachedCategory != _category;

          if (needsRefresh || _cache.isEmpty) {
            final response = await getTopHeadLines(_country, _category);
            if (response['status'] != 'success') {
              throw Exception('Failed to fetch articles: ${response['data']}');
            }

            final List raw =
                (response['data']?['articles'] as List?) ?? const [];
            _cache = raw.map<ArticleModel>((e) {
              return ArticleModel(
                author: e['author'] ?? 'Unknown',
                title: e['title'] ?? '',
                description: e['description'] ?? '',
                url: e['url'] ?? '',
                urlToImage: e['urlToImage'] ?? '',
                content: e['content'] ?? '',
              );
            }).toList();
            
            print('✅ Fetched ${_cache.length} articles for page $pageKey');

            _cachedCountry = _country;
            _cachedCategory = _category;
          }

          // Slice current page from cache
          final start = (pageKey - 1) * _pageSize;
          if (start >= _cache.length) {
            print('⚠️ Page $pageKey: start index $start >= cache length ${_cache.length}');
            return <ArticleModel>[];
          }

          final end = (start + _pageSize).clamp(0, _cache.length);
          final pageArticles = _cache.sublist(start, end);
          print('📄 Page $pageKey: returning ${pageArticles.length} articles (start: $start, end: $end, total cached: ${_cache.length})');
          return pageArticles;
        } catch (e) {
          print('❌ Error fetching page $pageKey: $e');
          CustomSnack.warningSnack(e.toString());
          return <ArticleModel>[];
        }
      },
    );

    // Kick off initial load
    pagingController.refresh();
  }

  // Country change → refresh
  void changeLocation(String value) {
    _country = value;
    _invalidateAndRefresh();
    update();
  }

  // Category change → refresh
  void setCategory(String value) {
    _category = value;
    _invalidateAndRefresh();
    update();
  }

  // Back-compat for your existing call signature
  Future<void> fetchPage(int _ignoredPageKey, String categoryName) async {
    setCategory(categoryName);
  }

  void _invalidateAndRefresh() {
    _cache = [];
    _cachedCountry = null;
    _cachedCategory = null;
    pagingController.refresh();
  }

  @override
  void onClose() {
    pagingController.dispose();
    controller.dispose();
    super.onClose();
  }

}
