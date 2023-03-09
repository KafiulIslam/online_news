import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/color.dart';
import '../utils/constant_widget.dart';


class NewsDetails extends StatefulWidget {
  final String newsUrl;
  const NewsDetails({Key? key,required this.newsUrl}) : super(key: key);

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController _webViewController;
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(onPressed: (){
            Get.back();
          },icon: const Icon(Icons.arrow_back_ios,color: white,size: 22,),),
          title: appTitle,
        ),
         body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.newsUrl,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _controller.complete(controller);
              },
              onProgress: (int progress) {},
              onPageStarted: (String url) {
                ///TODO: header and footer will be removed///
                setState(() {
                  _isLoading = false;
                });
                // _webViewController.runJavascript(
                //     "document.getElementsByTagName('header')[0].style.display='none'");
                // _webViewController.runJavascript(
                //     "document.getElementsByTagName('footer')[0].style.display='none'");
                // _webViewController
                //     .runJavascript(
                //     ("javascript:(function() { " +
                //         "var head = document.getElementsByTagName('header')[0];" +
                //         "head.parentNode.removeChild(head);" +
                //         "var footer = document.getElementsByTagName('footer')[0];" +
                //         "footer.parentNode.removeChild(footer);" +
                //         "})()")
                //      // "document.getElementsByTagName('header')[0].style.display='none'"
                // ).then((value) =>
                //     debugPrint('header is deleting'))
                //     .catchError((onError) => debugPrint('$onError'));
              },
              onPageFinished: (String url) {},
            ),
            _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,)) : Stack()
          ],
        )
      ),
    );
  }
}
