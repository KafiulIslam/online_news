import 'package:country_picker/country_picker.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../utils/color.dart';
import '../../utils/constant_widget.dart';
import '../../controller/state/article_state.dart';
import '../../controller/state/category_state.dart';
import '../../model/article_model.dart';
import '../auth/login.dart';
import '../news_details.dart';
import '../widgets/blog_tile.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  final NewsCategoryState _categoryStateController =
  Get.put(NewsCategoryState());
  final ArticleState _articleStateController = Get.put(ArticleState());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0.0,
        title: appTitle,
        leading: IconButton(
            onPressed: () {
              ZoomDrawer.of(context)?.toggle();
            },
            icon: const Icon(
              Icons.menu,
              color: white,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.off(()=> const LoginScreen());
              },
              icon: const Icon(
                Icons.logout,
                color: white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, right: 16.0, left: 16.0, bottom: 0.0),
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
                              _articleStateController.fetchPage(
                                  1, _categoryStateController.categoryName);
                              _articleStateController.pagingController
                                  .refresh();
                            },
                            child:
                            _categoryStateController.categories[index]);
                      }),
                );
              }),
              verticalSpacer,
              GetBuilder<ArticleState>(builder: (_) {
                final controller = _articleStateController.pagingController;
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(() => controller.refresh()),
                    child: PagedListView<int, ArticleModel>.separated(
                      state: controller.value,
                      fetchNextPage: controller.fetchNextPage,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 32,
                      ),
                      builderDelegate:
                      PagedChildBuilderDelegate<ArticleModel>(
                          itemBuilder: (context, item, index) => BlogTile(
                            onTap: () {
                              Get.to(() =>
                                  NewsDetails(newsUrl: item.url!));
                            },
                            title: item.title,
                            imageUrl: item.urlToImage,
                            description: item.description,
                            detailsUrl: item.url,
                          )),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: GetBuilder<ArticleState>(builder: (_) {
        return FloatingActionButton(
          backgroundColor: white,
          elevation: 8.0,
          onPressed: () {
            showCountryPicker(
              context: context,
              onSelect: (Country country) {
                _articleStateController.changeLocation(country.countryCode);
                _articleStateController.pagingController.refresh();
              },
            );
          },
          child: Text(
            EmojiConverter.fromAlpha2CountryCode(
                _articleStateController.searchController),
            style: const TextStyle(fontSize: 25),
          ),
        );
      }),
    );
  }
}
