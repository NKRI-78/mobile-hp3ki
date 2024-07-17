import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:video_compress/video_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_image_camera.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_link.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_video.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_image.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_doc.dart';
import 'package:hp3ki/views/screens/feed/widgets/create_post_text.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class InputPostComponent extends StatefulWidget {
  const InputPostComponent({
    Key? key,
  }) : super(key: key);
  @override
  InputPostComponentState createState() => InputPostComponentState();
}

class InputPostComponentState extends State<InputPostComponent> {
  ImageSource? imageSource;
  File? fileVideo;
  Uint8List? thumbnail;
  int? videoSize;
  List<Asset> images = [];
  List<Asset> resultList = [];
  List<File> files = [];
  final String membershipStatus = SharedPrefs.getUserMemberType().trim();

  void uploadPic() async {
    if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
      context.read<ProfileProvider>().showNonPlatinumLimit(context);
    } else {
      imageSource = await showDialog<ImageSource?>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  getTranslated("SOURCE_IMAGE", context),
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  MaterialButton(
                    child: Text(getTranslated("CAMERA", context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black)),
                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  MaterialButton(
                      child: Text(
                        getTranslated("GALLERY", context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black),
                      ),
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.gallery))
                ],
              ));
      if (imageSource == ImageSource.camera) {
        XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            maxHeight: 720.0,
            maxWidth: 1280.0,
            imageQuality: 70);
        if (pickedFile != null) {
          NS.push(context, CreatePostImageCameraScreen(pickedFile));
        }
      }
      if (imageSource == ImageSource.gallery) {
        files = [];
        var pickerFiles = await ImagePicker().pickMultiImage(
            maxHeight: 720.0, 
            maxWidth: 1280.0, 
            imageQuality: 70,
        );

        if (pickerFiles.isEmpty) {
          return;
        }
        if (pickerFiles.length > 8) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hanya dapat upload 8 gambar')));
        }
        for (var imageAsset in pickerFiles.take(8)) {
          // File compressedFile = await FlutterNativeImage.compressImage(
          //     imageAsset.path,
          //     quality: 70,
          //     percentage: 70);
          setState(() => files.add(File(imageAsset.path)));
        }
        Future.delayed(const Duration(seconds: 1), () {
          NS.push(
              context,
              CreatePostImageScreen(
                files: files,
              ));
        });
      }
    }
  }

  void postLink() {
    if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
      context.read<ProfileProvider>().showNonPlatinumLimit(context);
    } else {
      NS.push(context, const CreatePostLink());
    }
  }

  Future<void> uploadVid() async {
    if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
      context.read<ProfileProvider>().showNonPlatinumLimit(context);
    } else {
      ProgressDialog pr = ProgressDialog(context: context);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowMultiple: false,
          allowCompression: true,
          withData: false,
          withReadStream: true,
          onFileLoading: (FilePickerStatus filePickerStatus) {
            if (filePickerStatus == FilePickerStatus.picking) {
              pr.show(
                  max: 2,
                  msg: "${getTranslated("PLEASE_WAIT", context)}...",
                  borderRadius: 10.0,
                  backgroundColor: ColorResources.white,
                  progressBgColor: ColorResources.primary,
                  progressValueColor: ColorResources.white);
            }
            if (filePickerStatus == FilePickerStatus.done) {
              pr.close();
            }
          });
      if (result != null) {
        File file = File(result.files.single.path!);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 200) {
          ShowSnackbar.snackbar(context, getTranslated("SIZE_MAXIMUM", context),
              "", ColorResources.error);
          return;
        }
        setState(() {
          fileVideo = file;
        });
        await Future.wait(
            [generateThumbnail(fileVideo!), getVideoSize(fileVideo!)]);
        Future.delayed(const Duration(seconds: 1), () {
          NS.push(
              context,
              CreatePostVideoScreen(
                  file: file,
                  thumbnail: thumbnail,
                  videoSize: videoSize! / 1000));
        });
      }
    }
  }

  Future<void> generateThumbnail(File file) async {
    final thumbnailBytes = await VideoCompress.getByteThumbnail(file.path);
    setState(() {
      thumbnail = thumbnailBytes;
    });
  }

  Future<void> getVideoSize(File file) async {
    final size = await file.length();
    setState(() {
      videoSize = size;
    });
  }

  void uploadDoc() async {
    if (membershipStatus != "PLATINUM" || membershipStatus == "-") {
      context.read<ProfileProvider>().showNonPlatinumLimit(context);
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
          "doc",
          "docx",
          "xls",
          "xlsx",
          "ppt",
          "ppt",
          "pptx",
          "txt"
        ],
        allowCompression: true,
      );
      if (result != null) {
        for (int i = 0; i < result.files.length; i++) {
          if (result.files[i].size > 50000000) {
            ShowSnackbar.snackbar(
                context,
                getTranslated("SIZE_MAXIMUM", context),
                "",
                ColorResources.error);
            return;
          }
        }
        NS.push(context, CreatePostDocScreen(files: result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.max, children: [
              Consumer<ProfileProvider>(builder: (BuildContext context,
                  ProfileProvider profileProvider, Widget? child) {
                return CachedNetworkImage(
                  imageUrl: profileProvider.user?.avatar ??
                      "https://p7.hiclipart.com/preview/92/319/609/computer-icons-person-clip-art-name.jpg",
                  imageBuilder:
                      (BuildContext context, ImageProvider imageProvider) {
                    return CircleAvatar(
                      backgroundColor: ColorResources.transparent,
                      backgroundImage: imageProvider,
                      radius: 20.0,
                    );
                  },
                  placeholder: (BuildContext context, _) {
                    return const CircleAvatar(
                      backgroundColor: ColorResources.black,
                      backgroundImage:
                          AssetImage('assets/images/icons/ic-person.png'),
                      radius: 20.0,
                    );
                  },
                  errorWidget: (BuildContext context, _, dynamic data) {
                    return const CircleAvatar(
                      backgroundColor: ColorResources.black,
                      backgroundImage:
                          AssetImage('assets/images/icons/ic-person.png'),
                      radius: 20.0,
                    );
                  },
                );
              }),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  readOnly: true,
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault),
                  maxLines: 1,
                  decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintText: getTranslated("WRITE_POST", context),
                      hintStyle: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                  onTap: () {
                    if (membershipStatus != "PLATINUM" ||
                        membershipStatus == "-") {
                      context
                          .read<ProfileProvider>()
                          .showNonPlatinumLimit(context);
                    } else {
                      NS.push(context, const CreatePostText());
                    }
                  },
                ),
              )
            ]),
            SizedBox(
              height: 56.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: uploadPic,
                    icon:
                        const Icon(Icons.image, color: ColorResources.primary),
                  ),
                  IconButton(
                    onPressed: uploadVid,
                    icon: const Icon(
                      Icons.video_call,
                      color: ColorResources.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: postLink,
                    icon: const Icon(
                      Icons.attach_file,
                      color: ColorResources.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: uploadDoc,
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: ColorResources.primary,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
