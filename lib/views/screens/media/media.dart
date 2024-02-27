import 'package:flutter/material.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/views/webview/webview.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({ Key? key }) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return const Scaffold(
      backgroundColor: ColorResources.backgroundDisabled,
      body: WebViewScreen(url: 'https://linktr.ee/hp3ki', title: 'Sosial Media')
    );
  }
}