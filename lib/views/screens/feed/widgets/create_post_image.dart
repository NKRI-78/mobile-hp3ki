import 'dart:io';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/providers/feed/feed.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';

class CreatePostImageScreen extends StatefulWidget {
  final List<File>? files;
  const CreatePostImageScreen({
    Key? key, 
    this.files,
  }) : super(key: key);
  @override
  _CreatePostImageScreenState createState() => _CreatePostImageScreenState();
}

class _CreatePostImageScreenState extends State<CreatePostImageScreen> {

  late TextEditingController captionC;
  int current = 0;
  
  @override 
  void initState() {
    super.initState();
    captionC = TextEditingController();
  }

  @override 
  void dispose() {
    captionC.dispose();
    super.dispose();
  } 

  Widget displaySinglePictures() {
    File file = File(widget.files!.first.path);
    return SizedBox(
      height: 180.0,
      child: Image.file(file,
        fit: BoxFit.fitHeight,
        width: double.infinity,
      )
    );
  }

  Widget displayListPictures() {
    List<File> listFile = widget.files!.map((file) => File(file.path)).toList();
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() => current = index);
              }
            ),
            items: listFile.map((i) {
              File demoImage = File(i.path);
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: Image.file(
                          demoImage,
                          fit: BoxFit.fill,
                        )
                      ),
                    ]
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: listFile.map((i) {
              int index = listFile.indexOf(i);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index
                  ? const Color.fromRGBO(0, 0, 0, 0.9)
                  : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
          )
        ]
      ),
    ); 
  }


  @override
  Widget build(BuildContext context) {
    return buildUI() ;
  }
  
  Widget buildUI() {
    return Scaffold(
      
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          buildAppBar(),
          buildBodyContent()
        ]
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
          backgroundColor: ColorResources.white,
          centerTitle: false,
          floating: true,
          title: Text(getTranslated("CREATE_POST", context), 
            style: poppinsRegular.copyWith(
              color: ColorResources.black,
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.bold
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorResources.black,
              size: Dimensions.iconSizeExtraLarge,
            ),
            onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
            ? () {} : () {
              NS.pop(context);
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                    ? () {} : () async {
                      String caption = captionC.text.trim();
                      
                      if(caption.isEmpty) {
                        ShowSnackbar.snackbar(context, 'Caption harus diisi', "", ColorResources.error);
                        return;
                      }

                      if(caption.isNotEmpty) {
                        if(caption.length < 10) {
                          ShowSnackbar.snackbar(context, getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
                          return;
                        }
                      } 
                      if(caption.length > 1000) {
                        ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMUM", context), "", ColorResources.error);
                        return;
                      }

                      context.read<FeedProvider>().setStateWritePost(WritePostStatus.loading);
                      
                      await context.read<FeedProvider>().sendPostImage(context, caption, widget.files!);          
                      
                      context.read<FeedProvider>().setStateWritePost(WritePostStatus.loaded);
                      NS.pop(context);
                    },
                    child: Container(
                      width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                      ? null : 80.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: ColorResources.primary,
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading  
                      ? const Loader(
                          color: ColorResources.white,
                        ) 
                      : Text('Post',
                        textAlign: TextAlign.center,
                        style: poppinsRegular.copyWith(
                          color: ColorResources.white
                        ),
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
        );
  }

  SliverToBoxAdapter buildBodyContent() {
    return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall, bottom: Dimensions.marginSizeSmall),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(widget.files!.length > 1)
                        displayListPictures()
                      else 
                        displaySinglePictures()
                    ],
                  ),
                ),
                TextField(
                  maxLines: 3,
                  controller: captionC,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                  decoration: InputDecoration(
                    labelText: "Caption",
                    labelStyle: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.grey
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, 
                        width: 1.0
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, 
                        width: 1.0
                      ),
                    ),
                  ),
                ),
              ]
            ),
          )
        );
  }
}