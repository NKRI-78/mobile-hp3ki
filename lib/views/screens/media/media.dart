import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:hp3ki/utils/color_resources.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Media",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: ColorResources.backgroundDisabled,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   width: double.infinity,
            //   margin: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
            //   child: Card(
            //       color: Colors.white,
            //       surfaceTintColor: Colors.white,
            //       child: InkWell(
            //         onTap: () async {
            //           await launchUrl(Uri.parse(
            //               'https://www.facebook.com/profile.php?id=61569660596466'));
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.all(12.0),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.max,
            //             children: [
            //               Image.asset(
            //                 'assets/images/icons/ic-fb.jpeg',
            //                 width: 30.0,
            //               ),
            //               const SizedBox(width: 10),
            //               const Text(
            //                 "Facebook",
            //                 style: TextStyle(
            //                     fontSize: 18.0, fontWeight: FontWeight.bold),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )),
            // ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
              child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse('https://asproindonesia.org'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/icons/ic-web.png',
                            width: 30.0,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Web",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
              child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://www.instagram.com/aspro.indonesia'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            'assets/images/icons/ic-ig.jpeg',
                            width: 30.0,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Instagram",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
              child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://www.youtube.com/@Asosiasiprofesiindonesia'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            'assets/images/icons/ic-yt.jpeg',
                            width: 30.0,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Youtube",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }
}
