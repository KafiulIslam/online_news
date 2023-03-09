import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawerState extends GetxController{

  ///TODO: there will be radhuni app link in google play store///
  String appLink = 'https://play.google.com/store/apps/details?id=com.kafiul.bmi_meter&fbclid=IwAR0N1zDc-DWRqe1YlHCE9teStWSqQ6cGl7hiur__878xMnqGS7wtScEh0Ro';

  Future<void> launchInBrowser(String fileUrl) async {
    final Uri _url = Uri.parse(fileUrl);
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $_url';
    }
  }

  // final MailOptions mailOptions = MailOptions(
  //   body: 'Hi Radhuni Team,',
  //   subject: 'Feedback on Radhuni app',
  //   recipients: ['kafiulraja135@gmail.com'],
  //   isHTML: true,
  //   attachments: [ 'path/to/image.png', ],
  // );

}

