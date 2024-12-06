import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoWebView extends StatefulWidget {
  final String videoUrl; // URL of the video to display

  const VideoWebView({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoWebView> createState() => VideoWebViewState();
}

class VideoWebViewState extends State<VideoWebView> {

  @override
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: WebView(
        initialUrl: widget.videoUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
