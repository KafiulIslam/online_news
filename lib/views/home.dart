import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:online_news_app/controller/state/article_state.dart';
import 'package:online_news_app/controller/state/category_state.dart';
import 'package:online_news_app/model/article_model.dart';
import 'package:online_news_app/views/news_details.dart';
import 'package:online_news_app/widgets/blog_tile.dart';
import '../controller/api/news_api.dart';
import '../controller/constant/color.dart';
import '../controller/constant/constant_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String location = '';
  final NewCategoryState _categoryStateController = Get.put(NewCategoryState());
  final ArticleState _articleStateController = Get.put(ArticleState());

  final _numberOfArticlePerRequest = 5;
  final PagingController<int, ArticleModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await getTopHeadLines(_articleStateController.searchController);
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
        _pagingController.appendLastPage(relatedArticles);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(relatedArticles, nextPageKey);
      }
    } catch (e) {
      print("error --> $e");
      _pagingController.error = e;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'News Today',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: white, fontSize: 20, fontWeight: FontWeight.w800)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<NewCategoryState>(builder: (_) {
                return Container(
                  alignment: Alignment.center,
                  height: 65,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _categoryStateController.categories.length,
                      itemBuilder: (context, index) {
                        return _categoryStateController.categories[index];
                      }),
                );
              }),
              verticalSpacer,
    GetBuilder<ArticleState>(builder: (_) {
    return Column(children: [
             TextFormField(
               onChanged: _articleStateController.changeLocation(_articleStateController.controller.text),
                controller: _articleStateController.controller,
               decoration: InputDecoration(
                 filled: true,
                 fillColor: white,
                 contentPadding: const EdgeInsets.all(16),
                 hintText: 'Search by country code',
                 hintStyle: GoogleFonts.roboto(
                     textStyle: const TextStyle(
                         color: deepAssTextColor,
                         fontSize: 16,
                         fontWeight: FontWeight.w400)),
                 suffixIcon: GestureDetector(
                   onTap: (){
                     _pagingController.addPageRequestListener((pageKey) {
                       _fetchPage(pageKey);
                     });
                     // _pagingController.refresh();
                   },
                   child: Container(
                     width: 40,
                     decoration: const BoxDecoration(
                         color: primaryColor,
                         borderRadius: BorderRadius.only(
                           topRight: Radius.circular(10),
                           bottomRight: Radius.circular(10),
                         )),
                     child: const Icon(Icons.search,color: white,),
                   ),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   borderSide: const BorderSide(color: deepAss),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   borderSide: const BorderSide(color: deepAss),
                 ),
                 focusColor: primaryColor,
               ),
             ),
             verticalSpacer,
             Container(
               height: MediaQuery.of(context).size.height - 100,
               child: RefreshIndicator(
                 onRefresh: () =>
                     Future.sync(() => _pagingController.refresh()),
                 child: PagedListView<int, ArticleModel>.separated(
                   pagingController: _pagingController,
                   separatorBuilder: (context, index) => const SizedBox(
                     height: 16,
                   ),
                   builderDelegate: PagedChildBuilderDelegate<ArticleModel>(
                       itemBuilder: (context, item, index) => BlogTile(
                         onTap: () {
                           Get.to(() => NewsDetails(newsUrl: item.url!));
                         },
                         title: item.title,
                         imageUrl: item.urlToImage,
                         description: item.description,
                       )),
                 ),
               ),
             )
           ],);}),
            ],
          ),
        ),
      ),
    );
  }
}
