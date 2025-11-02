import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_news_app/utils/image_path.dart';
import 'package:online_news_app/utils/typography.dart';
import 'package:online_news_app/views/widgets/custom_snack.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../utils/color.dart';
import '../auth/login.dart';
import 'home_widget/menu_tile.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String appLink =
      'https://play.google.com/store/apps/details?id=com.kafiul.bmi_meter&fbclid=IwAR0N1zDc-DWRqe1YlHCE9teStWSqQ6cGl7hiur__878xMnqGS7wtScEh0Ro';

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
              //app logo
              Image.asset(appLogo, height: 120, width: 130),
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
              //share app link
              MenuTile(
                  onTap: () {
                    Share.share(
                      'Click the link and get Global news app: $appLink',
                    );
                  },
                  title: 'Share',
                  icon: Icons.share_outlined),
              divider(context),
              // app ratings
              MenuTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      // set to false if you want to force a rating
                      builder: (context) => _dialog,
                    );
                  },
                  title: 'Ratings',
                  icon: Icons.star_outline),
              divider(context),
              //feedback
              MenuTile(
                  onTap: () async {
                    await FlutterMailer.send(MailOptions(
                      body: 'Hi Global News Team,',
                      subject: 'Feedback on Global News app',
                      recipients: ['kafiulraja135@gmail.com'],
                      isHTML: true,
                      attachments: [
                        'path/to/image.png',
                      ],
                    ));
                  },
                  title: 'Feedback',
                  icon: Icons.feedback_outlined),
              divider(context),
              //logout
              MenuTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.off(() => const LoginScreen());
                  },
                  title: 'Logout',
                  icon: Icons.logout),
              divider(context),
              //delete account
              MenuTile(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => _accountDeleteDialog,
                    );
                  },
                  title: 'Delete',
                  icon: Icons.delete_forever),
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
        await StoreRedirect.redirect(
            androidAppId: "com.kafi.globalnews",
            iOSAppId: "com.kafi.globalnews");
      }
    },
  );

  final _accountDeleteDialog = AlertDialog(
    title: const Text('Delete Account!', style: sixteenBlackStyle),
    content: const Text('Are you sure, to delete your account ?.',
        style: fourteenBlackStyle),
    actions: <Widget>[
      Container(
        alignment: Alignment.center,
        height: 35.0,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primaryColor,
        ),
        child: TextButton(
          child: Text(
            'Yes',
            style:
                fourteenBlackStyle.copyWith(fontSize: 14, color: Colors.white),
          ),
          onPressed: () async {
            try {
              await FirebaseAuth.instance.currentUser!.delete().then((value) {
                FirebaseAuth.instance.signOut();
                Get.off(() => const LoginScreen());
              });
            } catch (e) {
              CustomSnack.warningSnack(e.toString());
            }
          },
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 35.0,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primaryColor,
        ),
        child: TextButton(
          child: Text(
            'No',
            style:
                fourteenBlackStyle.copyWith(fontSize: 14, color: Colors.white),
          ),
          onPressed: () async {
            Get.back();
          },
        ),
      ),
    ],
  );

}
