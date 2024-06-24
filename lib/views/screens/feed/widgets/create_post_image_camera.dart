import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/providers/feed/feed.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';

class CreatePostImageCameraScreen extends StatefulWidget {
  final XFile? file;

  const CreatePostImageCameraScreen(
    this.file, {Key? key}
  ) : super(key: key);

  @override
  _CreatePostImageCameraScreenState createState() => _CreatePostImageCameraScreenState();
}

class _CreatePostImageCameraScreenState extends State<CreatePostImageCameraScreen> {

  late TextEditingController captionC;
  
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

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        File file = File(widget.file!.path);
        return Scaffold(
          
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              buildAppBar(context, file),
              buildBodyContent(file)
            ]
          )
        );
      },
    );
  }

  SliverAppBar buildAppBar(BuildContext context, File file) {
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
        onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () {
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
                onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () async {
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
                    ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
                    return;
                  }
                  context.read<FeedProvider>().setStateWritePost(WritePostStatus.loading);
                  await context.read<FeedProvider>().sendPostImageCamera(context, caption, file);
                  context.read<FeedProvider>().setStateWritePost(WritePostStatus.loaded);
                  NS.pop(context);
                },
                child: Container(
                  width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? null : 80.0,
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

  SliverToBoxAdapter buildBodyContent(File file) {
    return SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Image.file(
                        file,
                        fit: BoxFit.fill,
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                      child: TextField(
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
                    ),
                  ],
                ),
              )
            );
  }
}
