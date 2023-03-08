import 'package:country_picker/country_picker.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:online_news_app/controller/state/article_state.dart';
import 'package:online_news_app/controller/state/category_state.dart';
import 'package:online_news_app/model/article_model.dart';
import 'package:online_news_app/views/home/home_body.dart';
import 'package:online_news_app/views/home/home_drawer.dart';
import 'package:online_news_app/views/news_details.dart';
import 'package:online_news_app/views/widgets/blog_tile.dart';
import '../../controller/constant/color.dart';
import '../../controller/constant/constant_widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ZoomDrawerController _drawerController = ZoomDrawerController();

    return ZoomDrawer(
      controller: _drawerController,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      style: DrawerStyle.defaultStyle,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 200),
      angle: 0.0,
      menuBackgroundColor: Theme.of(context).primaryColor,
      mainScreen: const HomeBody(),
      menuScreen: const HomeDrawer(),
    );
  }
}
