import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';

class PreviewImageScreen extends StatefulWidget {
  final List<dynamic>? medias;
  final int? id;

  const PreviewImageScreen({
    this.medias,
    this.id,
    Key? key, 
  }) : super(key: key);

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {

  var current = 0;
  
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

    current = widget.id!;

    return buildUI();
  }
  
  Widget buildUI() {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: ColorResources.black,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: ColorResources.white,
          ),
          onPressed: () {
            NS.pop(context);
          }
        ),
      ),
      backgroundColor: ColorResources.black,
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enableInfiniteScroll: false,
            initialPage: current,
            viewportFraction: 1.0,
            onPageChanged: (int i, CarouselPageChangedReason reason) {
              setState(() => current = i);
            }
          ),
          items: widget.medias!.map((i) {
            return CachedNetworkImage(
              imageUrl: "${i.path}",
              imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              errorWidget: (BuildContext context, String url, dynamic _) {
                return Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  width: double.infinity,
                  height: 200.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/images/logo/logo.png")
                    )
                  ),
                );
              },
              placeholder: (BuildContext context, String url) {
                return Shimmer.fromColors(
                  highlightColor: ColorResources.white,
                  baseColor: Colors.grey[200]!,
                  child: Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    width: double.infinity,
                    height: 200.0,
                    color: ColorResources.white
                  )  
                );
              } 
            );
          }).toList()
      )
      
      // Center(
      //   child: Hero(
      //     tag: 'Image',
      //     child: CachedNetworkImage(
      //       imageUrl: widget.img!,
      //       imageBuilder: (BuildContext context, ImageProvider imageProvider) => PhotoView(
      //         initialScale: PhotoViewComputedScale.contained * 1.1,
      //         imageProvider: imageProvider,
      //       ),
      //       placeholder: (BuildContext context, String url) => Shimmer.fromColors(
      //         highlightColor: ColorResources.white,
      //         baseColor: Colors.grey[200]!,
      //         child: Container(
      //           margin: const EdgeInsets.all(0.0),
      //           padding: const EdgeInsets.all(0.0),
      //           width: double.infinity,
      //           height: 200.0,
      //           color: Colors.grey
      //         )  
      //       ),
      //     ),
      //   )
      // ),
      )
    );
  }
}