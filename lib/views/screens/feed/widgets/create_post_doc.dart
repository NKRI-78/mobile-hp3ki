import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/feed/feed.dart';

import 'package:hp3ki/views/basewidgets/loader/circular.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class CreatePostDocScreen extends StatefulWidget {
  final FilePickerResult? files;
  const CreatePostDocScreen({
    Key? key, 
    this.files,
  }) : super(key: key);
  @override
  _CreatePostDocScreenState createState() => _CreatePostDocScreenState();
}

class _CreatePostDocScreenState extends State<CreatePostDocScreen> {

  late TextEditingController captionC;
  Color? color;

  Widget displaySingleDoc(BuildContext context) {   
    File? file = File(widget.files!.files.single.path!);
    return Container(
      width: 200.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${getTranslated("FILE_NAME", context)} : ${basename(file.path)}', 
            style: poppinsRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeDefault
            ) 
          ),
          const SizedBox(height: 6.0),
          Text('${getTranslated("FILE_SIZE", context)} : ${filesize(file.lengthSync())}', 
            style: poppinsRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeDefault
            ) 
          ),
        ],
      ) 
    );
  }

  @override 
  void initState() {
    super.initState();
    captionC = TextEditingController();
    File? file = File(widget.files!.files.single.path!);
    Future.delayed(Duration.zero, () {
      switch (basename(file.path).split('.').last) {
        case 'pdf':
          setState(() => color = Colors.red[300]);
        break;
        case 'ppt':
          setState(() => color = Colors.red[300]);
        break;
        case 'pptx':
          setState(() => color = Colors.red[300]);
        break;
        case 'txt':
          setState(() => color = Colors.blueGrey[300]);
        break;
        case 'xls':
          setState(() => color = Colors.green[300]);
        break;
        case 'xlsx':
          setState(() => color = Colors.green[300]);
        break;
          case 'doc':
          setState(() => color = Colors.green[300]);
        break;
        case 'docx':
          setState(() => color = Colors.green[300]);
        break;
        default:
      }
    });
  }

  @override 
  void dispose() {
    captionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          buildAppBar(context),
          buildBodyContent(context)
        ]
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorResources.white,
      title: Text(getTranslated("CREATE_POST", context), 
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorResources.black,
            size: Dimensions.iconSizeExtraLarge,
          ),
          onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? () {} : () {
            NS.pop(context);
          },
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                  }                  context.read<FeedProvider>().setStateWritePost(WritePostStatus.loading);
                  await context.read<FeedProvider>().sendPostDoc(context, caption, widget.files!);
                  context.read<FeedProvider>().setStateWritePost(WritePostStatus.loaded);
                  NS.pop(context);            
                },
                child: Container(
                  width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                  ? null 
                  : 80.0,
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
                      color: ColorResources.white,
                    ),
                  ),
                ),
              )
            ]
          ),
        )
      ],
      centerTitle: false,
      floating: true,
    );
  }

  SliverToBoxAdapter buildBodyContent(BuildContext context) {
    return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            height: MediaQuery.sizeOf(context).height - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(widget.files != null)
                  displaySingleDoc(context),
                const SizedBox(height: 10.0),
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
              ],
            ),
          )
        );
  }
  
}