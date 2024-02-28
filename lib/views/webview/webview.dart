import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/basewidgets/loader/square.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  final bool isExternalApp;
  final bool? isFile;
  const WebViewScreen(
      {Key? key,
      this.isFile,
      this.isExternalApp = false,
      required this.url,
      required this.title})
      : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? controllerGlobal;
  bool isLoading = true;

  Future<void> launch(url) async {
    if (await canLaunchUrl(url)) {
      url = Uri.parse(url);
      await launchUrl(
        url,
        mode: widget.isExternalApp
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
        webViewConfiguration:
            const WebViewConfiguration(enableJavaScript: true),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: widget.title, isWebview: true)
            .buildAppBar(context),
        backgroundColor: ColorResources.backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    WebView(
                      initialUrl: widget.isFile == true
                          ? "https://docs.google.com/viewer?url=${widget.url}"
                          : widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      userAgent: AppConstants.mobileUa,
                      gestureNavigationEnabled: true,
                      onWebViewCreated: (WebViewController webViewController) {
                        controllerGlobal = webViewController;
                      },
                      navigationDelegate: (NavigationRequest request) async {
                        if (request.url.contains('tel:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        } else if (request.url.contains('whatsapp:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        } else if (request.url.contains('mailto:')) {
                          await launch(request.url);
                          return NavigationDecision.prevent;
                        } else if (request.url.contains('fb://profile/')) {
                          if (Platform.isAndroid) {
                            request.url
                                .replaceAll('fb://profile/', 'fb://page/');
                          }
                          await launch(Uri.parse(request.url));
                          return NavigationDecision.navigate;
                        }
                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) async {
                        setState(() => isLoading = true);
                      },
                      onPageFinished: (String url) {
                        setState(() => isLoading = false);
                      },
                    ),
                    isLoading
                        ? const Center(
                            child: SquareLoader(color: ColorResources.primary),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> exitApp() async {
    if (controllerGlobal != null) {
      if (await controllerGlobal!.canGoBack()) {
        controllerGlobal!.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(true);
    }
  }
}
