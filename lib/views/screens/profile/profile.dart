import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/providers/media/media.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/ecommerce/ecommerce.dart';

import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/dialog/custom/custom.dart';

import 'package:hp3ki/views/screens/upgrademember/index.dart';
import 'package:hp3ki/views/screens/ecommerce/store/store_info.dart';
import 'package:hp3ki/views/screens/ecommerce/store/create_update_store.dart';
import 'package:hp3ki/views/screens/auth/change_password.dart';
import 'package:hp3ki/views/screens/privacy_policy/privacy_policy.dart';
import 'package:hp3ki/views/screens/profile/edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  File? file;
  ImageSource? imageSource;
  String? pfpPath;

  bool isDownload = false;

  bool isPlatinum = false;
  bool hasRemainder = false;

  final GlobalKey ktaImageKey = GlobalKey();

  late EcommerceProvider ecommerceProvider;
  late ProfileProvider profileProvider;

  late int remainderCount;

  Future<void> getData() async {
    if (!mounted) return;
    context.read<ProfileProvider>().getProfile(context);

    if (!mounted) return;
    context.read<EcommerceProvider>().checkStoreOwner();

    if (!mounted) return;
    file = null;

    if (!mounted) return;
    context.read<ProfileProvider>().remote();

    if (!mounted) return;
    if (context.read<ProfileProvider>().user!.memberType != "PLATINUM") {
      isPlatinum = false;
    } else {
      isPlatinum = true;
    }
    final remainingDays = context.read<ProfileProvider>().user!.remainingDays!;

    if (remainingDays > 0 && remainingDays < 11) {
      hasRemainder = true;
      remainderCount = context.read<ProfileProvider>().user!.remainingDays ?? 0;
    } else {
      hasRemainder = false;
    }
  }

  Future<String?> uploadPicture(BuildContext context, File file) async {
    final res = await context.read<MediaProvider>().postMedia(file);
    Map data = res!.data;
    return data["data"]["path"];
  }

  Future<void> editPicture() async {
    pfpPath = await uploadPicture(context, file!);

    await context
        .read<ProfileProvider>()
        .updateProfilePicture(context, pfpPath: pfpPath!);

    setState(() => file = null);
  }

  Future<void> chooseFile() async {
    imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                getTranslated("SOURCE_IMAGE", context),
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.primary),
              ),
              actions: [
                MaterialButton(
                  child: Text(getTranslated("CAMERA", context),
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.primary)),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                    child: Text(
                      getTranslated("GALLERY", context),
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.primary),
                    ),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery))
              ],
            ));
    if (imageSource != null) {
      if (imageSource == ImageSource.gallery) {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        File? cropped = await ImageCropper().cropImage(
            sourcePath: pickedFile!.path,
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: getTranslated("CROP_IT", context),
                toolbarColor: Colors.blueGrey[900],
                toolbarWidgetColor: ColorResources.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));

        if (cropped != null) {
          setState(() => file = cropped);
        } else {
          setState(() => file = null);
        }
      } else {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );

        File? cropped = await ImageCropper().cropImage(
            sourcePath: pickedFile!.path,
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: getTranslated("CROP_IT", context),
                toolbarColor: Colors.blueGrey[900],
                toolbarWidgetColor: ColorResources.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: const IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));

        if (cropped != null) {
          setState(() => file = cropped);
        } else {
          setState(() => file = null);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    profileProvider = context.read<ProfileProvider>();
    ecommerceProvider = context.read<EcommerceProvider>();

    Future.microtask(() => getData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildBackgroundImage(),
        child: RefreshIndicator(
          color: ColorResources.primary,
          onRefresh: () {
            return Future.sync(() {
              getData();
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  buildUserKTA(),
                  isPlatinum
                      ? buildCreateStore()
                      : const SliverToBoxAdapter(child: SizedBox()),
                  buildUserDetails(),
                  buildNoReferral(),
                  buildChangePassword(),
                  buildPrivacy(),
                  buildLogout(),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter, child: buildUserInfoBox()),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
        backgroundBlendMode: BlendMode.darken,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorResources.primary,
              Color.fromARGB(255, 12, 59, 153),
            ]),
        image: DecorationImage(
            image: AssetImage('assets/images/background/bg.png'),
            opacity: 0.7,
            fit: BoxFit.cover));
  }

  SliverPadding buildUserKTA() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 30),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            RepaintBoundary(
              key: ktaImageKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 310,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeExtraLarge,
                          left: Dimensions.marginSizeExtraLarge,
                          right: Dimensions.marginSizeExtraLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(isPlatinum
                                ? "assets/images/profile/kta-prem.png"
                                : "assets/images/profile/kta-member.png"),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            left: 16, top: 27, bottom: 27, right: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Expanded(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       if (context
                            //               .read<ProfileProvider>()
                            //               .user
                            //               ?.organizationBahasa
                            //               ?.isNotEmpty ??
                            //           false)
                            //         FittedBox(
                            //           child: Text(
                            //             context
                            //                     .read<ProfileProvider>()
                            //                     .user
                            //                     ?.organizationBahasa ??
                            //                 "...",
                            //             style: poppinsRegular.copyWith(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 12,
                            //               color: ColorResources.black,
                            //             ),
                            //             maxLines: 1,
                            //           ),
                            //         ),
                            //       if (context
                            //               .read<ProfileProvider>()
                            //               .user
                            //               ?.organizationEnglish
                            //               ?.isNotEmpty ??
                            //           false)
                            //         FittedBox(
                            //           child: Text(
                            //             context
                            //                     .read<ProfileProvider>()
                            //                     .user
                            //                     ?.organizationEnglish
                            //                     ?.trim() ??
                            //                 "...",
                            //             style: poppinsRegular.copyWith(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 12,
                            //               color: ColorResources.black,
                            //             ),
                            //             maxLines: 1,
                            //           ),
                            //         ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 125.0,
                        left: 52.0,
                        child: file != null
                            ? InkWell(
                                onTap: chooseFile,
                                child: Container(
                                  height: 130.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: FileImage(file!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: chooseFile,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: context
                                          .read<ProfileProvider>()
                                          .user
                                          ?.avatar ??
                                      AppConstants.avatarError,
                                  imageBuilder: (BuildContext context,
                                      ImageProvider<Object> imageProvider) {
                                    return Container(
                                      height: 130.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (BuildContext context,
                                      String url, dynamic error) {
                                    return Container(
                                      height: 130.0,
                                      width: 120.0,
                                      decoration: BoxDecoration(
                                        color: ColorResources.greyDarkPrimary,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/icons/ic-person.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),

                      isDownload
                          ? const SizedBox()
                          : Positioned(
                              bottom: 75,
                              left: 140,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: file != null
                                        ? ColorResources.error
                                        : ColorResources.primary),
                                child: InkWell(
                                  onTap: file != null
                                      ? () {
                                          setState(() {
                                            file = null;
                                          });
                                        }
                                      : chooseFile,
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                    child: file != null
                                        ? const Icon(
                                            Icons.close,
                                            color: ColorResources.white,
                                            size: Dimensions.iconSizeDefault,
                                          )
                                        : const Icon(
                                            Icons.camera_alt,
                                            color: ColorResources.white,
                                            size: Dimensions.iconSizeDefault,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        top: 155,
                        left: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildOutlineText(
                              label: context
                                          .watch<ProfileProvider>()
                                          .profileStatus ==
                                      ProfileStatus.loading
                                  ? "..."
                                  : context
                                              .watch<ProfileProvider>()
                                              .profileStatus ==
                                          ProfileStatus.error
                                      ? "-"
                                      : context
                                          .read<ProfileProvider>()
                                          .user!
                                          .noMember!
                                          .toUpperCase(),
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.bold,
                              outlineColor: ColorResources.black,
                            ),
                            buildOutlineText(
                              label: context
                                          .watch<ProfileProvider>()
                                          .profileStatus ==
                                      ProfileStatus.loading
                                  ? "..."
                                  : context
                                              .watch<ProfileProvider>()
                                              .profileStatus ==
                                          ProfileStatus.error
                                      ? "-"
                                      : context
                                          .read<ProfileProvider>()
                                          .user!
                                          .fullname!
                                          .toUpperCase()
                                          .firstFewWords(),
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeOverLarge,
                              fontWeight: FontWeight.bold,
                              outlineColor: ColorResources.black,
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   top: isSmall ? 25 : 47,
                      //   left: 50,
                      //   child: Row(
                      //     children: [
                      //       CachedNetworkImage(
                      //         fit: BoxFit.fill,
                      //         imageUrl: context
                      //                 .read<ProfileProvider>()
                      //                 .user
                      //                 ?.organizationPath ??
                      //             AppConstants.avatarError,
                      //         imageBuilder: (BuildContext context,
                      //             ImageProvider<Object> imageProvider) {
                      //           return Container(
                      //             height: 30.0,
                      //             width: 30.0,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(15.0),
                      //               image: DecorationImage(
                      //                 image: imageProvider,
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //         errorWidget: (BuildContext context, String url,
                      //             dynamic error) {
                      //           return Container(
                      //             height: 30.0,
                      //             width: 30.0,
                      //             decoration: BoxDecoration(
                      //               color: ColorResources.transparent,
                      //               borderRadius: BorderRadius.circular(15.0),
                      //               image: const DecorationImage(
                      //                 image: AssetImage(
                      //                     'assets/images/logo/logo.png'),
                      //                 fit: BoxFit.fill,
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //       const SizedBox(
                      //         width: 15,
                      //       ),
                      //       // Column(
                      //       //   crossAxisAlignment: CrossAxisAlignment.start,
                      //       //   children: [
                      //       //     Text(
                      //       //       context
                      //       //               .read<ProfileProvider>()
                      //       //               .user
                      //       //               ?.organizationBahasa
                      //       //               ?.trim() ??
                      //       //           "...",
                      //       //       style: poppinsRegular.copyWith(
                      //       //         fontWeight: FontWeight.bold,
                      //       //         fontSize: Dimensions.fontSizeSmall,
                      //       //         color: ColorResources.black,
                      //       //       ),
                      //       //     ),
                      //       //     Text(
                      //       //       context
                      //       //               .read<ProfileProvider>()
                      //       //               .user
                      //       //               ?.organizationEnglish
                      //       //               ?.trim() ??
                      //       //           "...",
                      //       //       style: poppinsRegular.copyWith(
                      //       //         fontWeight: FontWeight.bold,
                      //       //         fontSize: Dimensions.fontSizeSmall,
                      //       //         color: ColorResources.black,
                      //       //       ),
                      //       //     ),
                      //       //   ],
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                      Positioned(
                        bottom: 30,
                        right: 40,
                        child: QrImageView(
                          data:
                              context.read<ProfileProvider>().user?.noMember ??
                                  "-",
                          size: 60.0,
                        ),
                      )
                    ],
                  ),
                  file != null
                      ? Container(
                          margin: const EdgeInsets.only(
                            left: Dimensions.marginSizeExtraLarge,
                            right: Dimensions.marginSizeExtraLarge,
                            bottom: Dimensions.marginSizeSmall,
                          ),
                          child: CustomButton(
                            customText: true,
                            text: Text(
                              'Ubah Foto Profil',
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  color: ColorResources.white),
                            ),
                            btnColor: ColorResources.success,
                            isBorderRadius: true,
                            sizeBorderRadius: 10.0,
                            isBoxShadow: true,
                            onTap: () async {
                              editPicture();
                            },
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: isDownload
                        ? () {}
                        : () async {
                            setState(() {
                              isDownload = true;
                            });

                            Future.delayed(const Duration(seconds: 1),
                                () async {
                              final RenderRepaintBoundary boundary =
                                  ktaImageKey.currentContext!.findRenderObject()
                                      as RenderRepaintBoundary;
                              final ui.Image image =
                                  await boundary.toImage(pixelRatio: 10);
                              ByteData? byteData = await image.toByteData(
                                  format: ui.ImageByteFormat.png);
                              var pngBytes = byteData!.buffer.asUint8List();

                              String dir = (await getTemporaryDirectory()).path;
                              File file =
                                  File("$dir/kta-hp3ki-${DateTime.now()}.jpg");
                              await file.writeAsBytes(
                                pngBytes,
                              );

                              await GallerySaver.saveImage(file.path);

                              // final params = SaveFileDialogParams(sourceFilePath: file.path);
                              // final finalPath = await FlutterFileDialog.saveFile(params: params);
                            });

                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isDownload = false;
                              });
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          isDownload
                              ? Text(getTranslated("LOADING", context))
                              : Text(getTranslated("DOWNLOAD", context)),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(Icons.download_outlined),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
  }

  Stack buildOutlineText(
      {required String label,
      required Color color,
      required double fontSize,
      required FontWeight fontWeight,
      required Color outlineColor}) {
    return Stack(
      children: [
        Text(
          label,
          style: robotoRegular.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..color = outlineColor
              ..strokeWidth = 2,
          ),
        ),
        Text(
          label,
          style: robotoRegular.copyWith(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter buildUserDetails() {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const SizedBox(
            height: 350,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(top: hasRemainder ? 30.0 : 20.0),
            child: GestureDetector(
              onTap: () {
                NS.push(context, const EditProfileScreen());
              },
              child: Container(
                height: 300,
                margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.marginSizeExtraLarge,
                ),
                decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(141, 68, 99, 158).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: kElevationToShadow[2]),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Nama : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.fullname!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'Email : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.email!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'No. Telepon : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.phone!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'No. KTP  : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.noKtp!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'Alamat (KTP) : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.addressKtp!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'Organisasi : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.organization!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                            Text(
                              'Profesi : ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.job!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              NS.push(context, const EditProfileScreen());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorResources.white.withOpacity(0.5),
                              size: Dimensions.iconSizeLarge,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isPlatinum
            ? hasRemainder
              ? context.read<ProfileProvider>().isActive == 0
                ? const SizedBox()
                : buildExtendPremiumButton(label: 'Perpanjang Membership')
              : const SizedBox()
            : context.read<ProfileProvider>().isActive == 0
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: buildActionPremiumButton(label: 'UPGRADE MEMBERSHIP'),
                )
        ],
      ),
    );
  }

  Widget buildExtendPremiumButton({required String label}) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        height: 200,
        width: screenWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(141, 68, 99, 158)
                          .withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Tersisa $remainderCount hari lagi',
                      style: poppinsRegular.copyWith(
                        color: ColorResources.white,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: screenWidth * 0.5,
                child: buildActionPremiumButton(label: 'Perpanjang Membership'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionPremiumButton({required String label}) {
    return CustomButton(
      onTap: () {
        NS.push(context, const UpgradeMemberScreen());
      },
      btnColor: ColorResources.white,
      isBoxShadow: hasRemainder ? true : false,
      isBorderRadius: true,
      sizeBorderRadius: 30.0,
      customText: true,
      text: Text(
        label,
        style: poppinsRegular.copyWith(
          color: ColorResources.primary,
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.fontSizeLarge,
        ),
      ),
    );
  }

  SliverToBoxAdapter buildNoReferral() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: buildOptionReferral(
          color: Colors.white,
          label: 'Kode referral',
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                  text: context.read<ProfileProvider>().user?.noReferral ?? ''),
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Nomor referral telah di copy"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter buildCreateStore() {
    return SliverToBoxAdapter(child: Consumer<EcommerceProvider>(
      builder:
          (BuildContext context, EcommerceProvider notifier, Widget? child) {
        if (notifier.checkStoreOwnerStatus == CheckStoreOwnerStatus.loading) {
          return const SizedBox();
        }
        if (notifier.checkStoreOwnerStatus == CheckStoreOwnerStatus.error) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: buildOptionContainer(
            color: Colors.white,
            label: notifier.ownerModel.data == null
                ? 'Buat Toko'
                : notifier.ownerModel.data!.haveStore
                    ? 'Toko Saya'
                    : 'Buat Toko',
            onTap: () {
              if (notifier.ownerModel.data!.haveStore) {
                NS.push(
                    context,
                    StoreInfoScreen(
                      storeId: notifier.ownerModel.data!.storeId,
                    ));
              } else {
                NS.push(context, const CreateStoreOrUpdateScreen());
              }
            },
          ),
        );
      },
    ));
  }

  SliverToBoxAdapter buildChangePassword() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: buildOptionContainer(
          color: Colors.white,
          label: 'Ubah Password',
          onTap: () {
            NS.push(context, const ChangePasswordScreen(isFromForget: false));
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter buildPrivacy() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: buildOptionContainer(
          color: Colors.white,
          label: 'Kebijakan',
          onTap: () {
            NS.push(context, const PrivacyPolicyScreen());
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter buildLogout() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: buildOptionContainer(
          color: Colors.red,
          label: 'Keluar',
          onTap: () {
            CustomDialog.askLogout(context);
          },
        ),
      ),
    );
  }

  Container buildOptionContainer(
      {required String label,
      required Color color,
      required void Function() onTap}) {
    return Container(
      margin: const EdgeInsets.only(
        left: Dimensions.marginSizeExtraLarge,
        right: Dimensions.marginSizeExtraLarge,
        bottom: Dimensions.marginSizeExtraLarge,
      ),
      decoration: BoxDecoration(
          color: const Color.fromARGB(141, 68, 99, 158).withOpacity(0.7),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: kElevationToShadow[2]),
      child: Material(
        color: ColorResources.transparent,
        child: InkWell(
          onDoubleTap: () {},
          onTap: onTap,
          borderRadius: BorderRadius.circular(30.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: poppinsRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: Dimensions.fontSizeExtraLarge,
                    shadows: kElevationToShadow[1],
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorResources.white.withOpacity(0.5),
                    size: Dimensions.iconSizeDefault,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildOptionReferral(
      {required String label,
      required Color color,
      required void Function() onTap}) {
    return Container(
      margin: const EdgeInsets.only(
        left: Dimensions.marginSizeExtraLarge,
        right: Dimensions.marginSizeExtraLarge,
        bottom: Dimensions.marginSizeExtraLarge,
      ),
      decoration: BoxDecoration(
          color: const Color.fromARGB(141, 68, 99, 158).withOpacity(0.7),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: kElevationToShadow[2]),
      child: Material(
        color: ColorResources.transparent,
        child: InkWell(
          onDoubleTap: () {},
          onTap: onTap,
          borderRadius: BorderRadius.circular(30.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      shadows: kElevationToShadow[1],
                    ),
                  ),
                ),
                Consumer<ProfileProvider>(builder: (context, notif, child) {
                  return Text(
                    notif.user?.noReferral ?? '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
                const SizedBox(
                  width: 6,
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    Icons.copy,
                    color: ColorResources.white.withOpacity(0.5),
                    size: Dimensions.iconSizeDefault,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserInfoBox() {
    return Container(
      margin: const EdgeInsets.all(
        Dimensions.marginSizeExtraLarge,
      ),
      child: Material(
        color: ColorResources.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            NS.pop();
          },
          child: Hero(
            tag: 'userBox',
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 10.0,
              color: const Color.fromARGB(141, 68, 99, 158).withOpacity(0.7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.marginSizeExtraSmall,
                    vertical: Dimensions.marginSizeSmall),
                child: ListTile(
                  horizontalTitleGap: 0.0,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40.0,
                    child: Consumer<ProfileProvider>(
                      builder: (BuildContext context,
                          ProfileProvider profileProvider, Widget? child) {
                        if (profileProvider.profileStatus ==
                            ProfileStatus.error) {
                          return Image.asset(
                            "assets/images/icons/ic-person.png",
                          );
                        }
                        return CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              context.read<ProfileProvider>().user?.avatar ??
                                  AppConstants.avatarError,
                          imageBuilder: (BuildContext context,
                              ImageProvider<Object> imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: imageProvider)),
                            );
                          },
                          errorWidget: (BuildContext context, String url,
                              dynamic error) {
                            return Image.asset(
                              "assets/images/icons/ic-person.png",
                            );
                          },
                        );
                      },
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated("WELCOME", context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.white,
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.shopping_bag,
                            size: Dimensions.iconSizeSmall,
                            color: ColorResources.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            getTranslated('MY_BALANCE', context),
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Hi, ${context.watch<ProfileProvider>().profileStatus == ProfileStatus.loading ? "..." : context.watch<ProfileProvider>().profileStatus == ProfileStatus.error ? "-" : context.read<ProfileProvider>().user!.fullname!.smallSentence()}',
                          maxLines: 1,
                          style: poppinsRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeExtraLarge,
                              color: ColorResources.white),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Helper.formatCurrency(0),
                          textAlign: TextAlign.right,
                          style: poppinsRegular.copyWith(
                            color: ColorResources.white,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
