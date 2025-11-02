import 'package:country_picker/country_picker.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../controller/state/article_state.dart';
import '../../controller/state/category_state.dart';
import '../../model/article_model.dart';
import '../../utils/color.dart';
import '../../utils/constant_widget.dart';
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
  Widget build(BuildContext context) {
    return GetBuilder<NewsCategoryState>(builder: (_) {
      return GetBuilder<ArticleState>(builder: (_) {
        final paging = _articleStateController.pagingController;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            elevation: 0.0,
            title: appTitle,
            leading: IconButton(
              onPressed: () => ZoomDrawer.of(context)?.toggle(),
              icon: Icon(Icons.menu, color: white),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.off(() => const LoginScreen());
                },
                icon: const Icon(Icons.logout, color: white),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
            child: Column(
              children: [
                // Categories
                SizedBox(
                  height: 65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _categoryStateController.categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _categoryStateController.changeCategory(index);
                          _articleStateController.setCategory(
                            _categoryStateController.categoryName,
                          );
                        },
                        child: _categoryStateController.categories[index],
                      );
                    },
                  ),
                ),
                verticalSpacer,

                // Articles (must own the scroll)
                Expanded(
                  child: ValueListenableBuilder<PagingState<int, ArticleModel>>(
                    valueListenable: paging,
                    builder: (context, state, _) {
                      return RefreshIndicator(
                        onRefresh: () => Future.sync(() => paging.refresh()),
                        child: PagedListView<int, ArticleModel>.separated(
                          state: state,
                          fetchNextPage: paging.fetchNextPage,
                          separatorBuilder: (_, __) => const SizedBox(height: 32),
                          builderDelegate: PagedChildBuilderDelegate<ArticleModel>(
                            itemBuilder: (context, item, index) => BlogTile(
                              onTap: () {
                                Get.to(() => NewsDetails(newsUrl: item.url!));
                              },
                              title: item.title,
                              imageUrl: item.urlToImage,
                              description: item.description,
                              detailsUrl: item.url,
                            ),
                            // Optional custom indicators:
                            firstPageProgressIndicatorBuilder: (_) =>
                                const Center(child: CircularProgressIndicator()),
                            newPageProgressIndicatorBuilder: (_) =>
                                const Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (_) =>
                                const Center(child: Text('Failed to load')),
                            noItemsFoundIndicatorBuilder: (_) =>
                                const Center(child: Text('No articles')),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: white,
            elevation: 8.0,
            onPressed: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  _articleStateController.changeLocation(country.countryCode);
                },
              );
            },
            child: Text(
              EmojiConverter.fromAlpha2CountryCode(
                _articleStateController.searchController,
              ),
              style: const TextStyle(fontSize: 25),
            ),
          ),
        );
      });
    });
  }
}
