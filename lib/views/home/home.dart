import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:online_news_app/views/home/home_body.dart';
import 'package:online_news_app/views/home/home_drawer.dart';


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
