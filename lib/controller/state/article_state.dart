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

  // Page size per request (smaller for better pagination testing)
  static const int _pageSize = 5;

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

        // If cache is empty, return 1 to trigger first fetch
        if (_cache.isEmpty) {
          return 1;
        }

        // Calculate how many pages we've loaded so far
        final pagesLoaded = (items.length / _pageSize).ceil();
        // Calculate total pages available from cache
        final totalPages = (_cache.length / _pageSize).ceil();

        // If we haven't loaded all pages yet, return the next page number
        if (pagesLoaded < totalPages) {
          final nextPage = pagesLoaded + 1;
          return nextPage;
        }

        // No more pages
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

            _cachedCountry = _country;
            _cachedCategory = _category;
          }

          // Slice current page from cache
          final start = (pageKey - 1) * _pageSize;
          if (start >= _cache.length) {
            return <ArticleModel>[];
          }

          final end = (start + _pageSize).clamp(0, _cache.length);
          final pageArticles = _cache.sublist(start, end);

          return pageArticles;
        } catch (e) {
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
