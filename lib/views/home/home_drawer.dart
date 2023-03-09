import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:online_news_app/utils/image_path.dart';
import 'package:online_news_app/views/widgets/custom_snack.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../utils/color.dart';
import 'home_widget/menu_tile.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  String appLink = 'https://play.google.com/store/apps/details?id=com.kafiul.bmi_meter&fbclid=IwAR0N1zDc-DWRqe1YlHCE9teStWSqQ6cGl7hiur__878xMnqGS7wtScEh0Ro';

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
              Image.asset(appLogo,height: 120,width: 130),
              const SizedBox(
                height: 60,
              ),
              MenuTile(
                  onTap: () {
                    ZoomDrawer.of(context)?.toggle();
                  },
                  title: 'News',
                  icon: Icons.newspaper_outlined),
              divider(context),
              MenuTile(
                  onTap: () {
                    Share.share(
                      'Click the link and get Global news app: $appLink',
                    );
                  },
                  title: 'Share',
                  icon: Icons.share_outlined),
              divider(context),
              MenuTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true, // set to false if you want to force a rating
                      builder: (context) => _dialog,
                    );
                  },
                  title: 'Ratings',
                  icon: Icons.star_outline),
              divider(context),
              MenuTile(
                  onTap: () async  {
                    await FlutterMailer.send(MailOptions(
                      body: 'Hi Global News Team,',
                      subject: 'Feedback on Global News app',
                      recipients: ['kafiulraja135@gmail.com'],
                      isHTML: true,
                      attachments: [ 'path/to/image.png', ],
                    ));
                  },
                  title: 'Feedback',
                  icon: Icons.feedback_outlined),
              // divider(context),
              // MenuTile(
              //     onTap: () {
              //
              //     },
              //     title: 'Help',
              //     icon: Icons.help_outline),
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

  final _dialog = RatingDialog(
    initialRating: 1.0,
    title: const Text(
      'Global News',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26.0,
        color: black,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
    message: const Text(
      'Tap a star to rate it on the Google Play Store.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: black,
        letterSpacing: 1,
      ),
    ),
    image: Image.asset(
      appLogo,
      height: 100,
      width: 100,
    ),
    submitButtonText: 'Submit',
    commentHint: 'Leave your comment here...',
    onCancelled: () {},
    onSubmitted: (response) async {
      if (response.rating < 2.0) {
        CustomSnack.warningSnack('You have to give more than two star!');
      } else {
        await StoreRedirect.redirect(androidAppId: "com.kafi.globalnews", iOSAppId: "com.kafi.globalnews");
      }
    },
  );

}
