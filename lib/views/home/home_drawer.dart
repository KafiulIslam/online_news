import 'package:flutter/material.dart';
import 'package:online_news_app/controller/constant/image_path.dart';
import 'home_widget/menu_tile.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF4E2),
      body: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              _profile(context),
              const SizedBox(
                height: 60,
              ),
              MenuTile(
                  onTap: () {
                    // Get.to(() => const CookedScreen());
                  },
                  title: 'News',
                  icon: Icons.newspaper_outlined),
              divider(context),
              MenuTile(
                  onTap: () {
                   // Get.to(() => const CookedScreen());
                  },
                  title: 'Share',
                  icon: Icons.share_outlined),
              divider(context),
              MenuTile(
                  onTap: () {
                    // Get.to(() => const CookedScreen());
                  },
                  title: 'Ratings',
                  icon: Icons.star_outline),
              divider(context),
              MenuTile(
                  onTap: () {
                    // Get.to(() => const CookedScreen());
                  },
                  title: 'Feedback',
                  icon: Icons.feedback_outlined),
              divider(context),
              MenuTile(
                  onTap: () {
                    // Get.to(() => const CookedScreen());
                  },
                  title: 'Help',
                  icon: Icons.help_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        color: Theme.of(context).primaryColor,
        height: 1,
      ),
    );
  }

  Widget _profile(BuildContext context) {
    return Image.asset(appLogo,height: 120,width: 130);
  }

}
