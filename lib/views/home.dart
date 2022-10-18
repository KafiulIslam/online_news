import 'package:country_picker/country_picker.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:online_news_app/controller/state/article_state.dart';
import 'package:online_news_app/controller/state/category_state.dart';
import 'package:online_news_app/model/article_model.dart';
import 'package:online_news_app/views/news_details.dart';
import 'package:online_news_app/views/widgets/blog_tile.dart';
import '../controller/constant/color.dart';
import '../controller/constant/constant_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NewsCategoryState _categoryStateController =
      Get.put(NewsCategoryState());
  final ArticleState _articleStateController = Get.put(ArticleState());

  var imogi;

  @override
  void initState() {
    _articleStateController.pagingController.addPageRequestListener((pageKey) {
      _articleStateController.fetchPage(
          pageKey, _categoryStateController.categoryName);
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
        actions: [
    GetBuilder<ArticleState>(builder: (_) {
    return TextButton(onPressed: (){
            showCountryPicker(
              context: context,
              onSelect: (Country country) {
                _articleStateController.changeLocation(country.countryCode);
                _articleStateController.pagingController.refresh();
              },
            );
          }, child: Text(
            EmojiConverter.fromAlpha2CountryCode(
                _articleStateController.searchController),
            style: const TextStyle(fontSize: 25),
          ));})
        ],
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
                              _articleStateController.pagingController
                                  .refresh();
                            },
                            child: _categoryStateController.categories[index]);
                      }),
                );
              }),
              verticalSpacer,
              GetBuilder<ArticleState>(builder: (_) {
                return Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(() =>
                        _articleStateController.pagingController.refresh()),
                    child: PagedListView<int, ArticleModel>.separated(
                      pagingController:
                          _articleStateController.pagingController,
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
