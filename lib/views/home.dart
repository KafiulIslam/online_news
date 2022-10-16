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

    final NewsCategoryState _categoryStateController = Get.put(NewsCategoryState());
    final ArticleState _articleStateController = Get.put(ArticleState());

  @override
  void initState() {
    _articleStateController.pagingController.addPageRequestListener((pageKey) {
      _articleStateController.fetchPage(pageKey,_categoryStateController.categoryName);
    });
    super.initState();
  }

  @override
  void dispose() {
    _articleStateController.pagingController.dispose();
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
              GetBuilder<NewsCategoryState>(builder: (_) {
                return Container(
                  alignment: Alignment.center,
                  height: 65,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _categoryStateController.categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              _categoryStateController.changeCategory(index);
                              ///TODO: filter is not working on change///
                              _articleStateController.pagingController.addPageRequestListener((pageKey) {
                                _articleStateController.fetchPage(pageKey,_categoryStateController.categoryName);
                              });
                            },
                            child: _categoryStateController.categories[index]);
                      }),
                );
              }),
              verticalSpacer,
              GetBuilder<ArticleState>(builder: (_) {
                return Column(
                  children: [
                    TextFormField(
                      onChanged: _articleStateController.changeLocation(
                          _articleStateController.controller.text),
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
                          onTap: () {
                            ///TODO: filter is not working on change///
                            _articleStateController.pagingController.addPageRequestListener((pageKey) {
                              _articleStateController.fetchPage(pageKey,_categoryStateController.categoryName);
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
                            child: const Icon(
                              Icons.search,
                              color: white,
                            ),
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
                            Future.sync(() => _articleStateController.pagingController.refresh()),
                        child: PagedListView<int, ArticleModel>.separated(
                          pagingController: _articleStateController.pagingController,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 32,
                          ),
                          builderDelegate:
                              PagedChildBuilderDelegate<ArticleModel>(
                                  itemBuilder: (context, item, index) =>
                                      BlogTile(
                                        onTap: () {
                                          Get.to(() =>
                                              NewsDetails(newsUrl: item.url!));
                                        },
                                        title: item.title,
                                        imageUrl: item.urlToImage,
                                        description: item.description,
                                      )),
                        ),
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
