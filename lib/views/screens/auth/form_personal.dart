import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import 'package:hp3ki/data/models/user/user.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

import 'package:hp3ki/providers/media/media.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/region_dropdown/region_dropdown.dart';

import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/dropdown/dropdown.dart';

class FormPersonalScreen extends StatefulWidget {
  const FormPersonalScreen({Key? key}) : super(key: key);

  @override
  State<FormPersonalScreen> createState() => FormPersonalScreenState();
}

class FormPersonalScreenState extends State<FormPersonalScreen> {
  File? selfiePhoto;
  File? ktpPhoto;
  ImageSource? imageSource;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController provinsiC;
  late TextEditingController kecamatanC;
  late TextEditingController kabupatenC;
  late TextEditingController desaC;

  late TextEditingController nameC;
  late FocusNode nameFn;

  late TextEditingController phoneNumberC;
  late FocusNode phoneNumberFn;

  late TextEditingController emailC;
  late FocusNode emailFn;

  late TextEditingController ktpC;
  late FocusNode ktpFn;

  late TextEditingController alamatKTPC;
  late FocusNode alamatKTPFn;

  late TextEditingController organisasiC;
  late FocusNode organisasiFn;

  late TextEditingController profesiC;
  late FocusNode profesiFn;

  dynamic currentBackPressTime;

  Future<void> submit() async {
    String name = nameC.text.trim();
    String ktp = ktpC.text.trim();
    String alamatKTP = alamatKTPC.text.trim();
    String provinsi = provinsiC.text.trim();
    String kecamatan = kecamatanC.text.trim();
    String kabupaten = kabupatenC.text.trim();
    String desa = desaC.text.trim();

    if (provinsi == "" || provinsi.isEmpty) {
      ShowSnackbar.snackbar(
           'Pilih Provinsi Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if (kabupaten == "" || kabupaten.isEmpty) {
      ShowSnackbar.snackbar(
           'Pilih Kabupaten Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if (kecamatan == "" || kecamatan.isEmpty) {
      ShowSnackbar.snackbar(
           'Pilih Kecamatan Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if (desa == "" || desa.isEmpty) {
      ShowSnackbar.snackbar(
           'Pilih Desa Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if (ktpPhoto == null) {
      ShowSnackbar.snackbar(
           'Upload Foto KTP', "", ColorResources.error);
      return;
    }
    if (selfiePhoto == null) {
      ShowSnackbar.snackbar(
           'Upload Foto Selfie', "", ColorResources.error);
      return;
    }

    if (formKey.currentState!.validate()) {

      final ktpPhotoPath = await context.read<MediaProvider>().postMedia(ktpPhoto!);
      final selfiePhotoPath = await context.read<MediaProvider>().postMedia(selfiePhoto!);

      String picKtp = ktpPhotoPath!.data['data']['path'];
      String avatar = selfiePhotoPath!.data['data']['path'];

      SharedPrefs.writePersonalData(
        fullname: name,
        addressKtp: alamatKTP,
        picKtp: picKtp,
        noKtp: ktp,
        avatar: avatar,
        provinceId: provinsi,
        province: context.read<RegionDropdownProvider>().currentProvince!,
        cityId: kabupaten,
        city: context.read<RegionDropdownProvider>().currentCity!,
        districtId: kecamatan,
        district: context.read<RegionDropdownProvider>().currentDistrict!,
        subdistrictId: desa,
        subdistrict: context.read<RegionDropdownProvider>().currentSubdistrict!,
      );

      await context.read<ProfileProvider>().setPersonalData(context);

    }
  }

  Future<void> chooseFileSelfie() async {
    imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Sumber Gambar Selfie',
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
                  onPressed: () async {
                    Navigator.pop(context, ImageSource.camera);
                  },
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
          setState(() {
            selfiePhoto = cropped;
          });
        } else {
          setState(() {
            selfiePhoto = null;
          });
        }
      } else {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
        );
        setState(() {
          selfiePhoto = File(pickedFile!.path);
        });
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
          setState(() {
            selfiePhoto = cropped;
          });
        } else {
          setState(() {
            selfiePhoto = null;
          });
        }
      }
    }
  }

  Future<void> chooseFileKTP() async {
    imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Sumber Gambar KTP',
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
          setState(() {
            ktpPhoto = cropped;
          });
        } else {
          setState(() {
            ktpPhoto = null;
          });
        }
      } else {
        XFile? pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );
        setState(() {
          ktpPhoto = File(pickedFile!.path);
        });
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
          setState(() {
            ktpPhoto = cropped;
          });
        } else {
          setState(() {
            ktpPhoto = null;
          });
        }
      }
    }
  }

  void getData() {
    provinsiC = context.read<RegionDropdownProvider>().currentProvinceIdC;
    kabupatenC = context.read<RegionDropdownProvider>().currentCityIdC;
    kecamatanC = context.read<RegionDropdownProvider>().currentDistrictIdC;
    desaC = context.read<RegionDropdownProvider>().currentSubdistrictIdC;

    nameC = TextEditingController();
    nameFn = FocusNode();

    phoneNumberC = TextEditingController();
    phoneNumberFn = FocusNode();

    emailC = TextEditingController();
    emailFn = FocusNode();

    ktpC = TextEditingController();
    ktpFn = FocusNode();

    organisasiC = TextEditingController();
    organisasiFn = FocusNode();

    profesiC = TextEditingController();
    profesiFn = FocusNode();

    alamatKTPC = TextEditingController();
    alamatKTPFn = FocusNode();

    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      if (mounted) {
        UserData user = context.read<ProfileProvider>().user!;
        nameC = TextEditingController(
            text: SharedPrefs.getRegFullname() ?? user.fullname);
        phoneNumberC = TextEditingController(
            text: SharedPrefs.getRegPhone() ?? user.phone);
        emailC = TextEditingController(
            text: SharedPrefs.getRegEmail() ?? user.email);
        organisasiC = TextEditingController(
            text: SharedPrefs.getRegOrgName() ?? user.organization);
        profesiC = TextEditingController(
            text: SharedPrefs.getRegJobName() ?? user.job);
        setState(() {});
      }
      if (mounted) {
        await Permission.storage.request();
        Permission.storage.isDenied.then((value) async {
          await Permission.storage.request();
        });
      }
    });
  }

  Future<void> initRegionProviderData() async {
    if (mounted) {
      context.read<RegionDropdownProvider>().initRegion(context);
    }
  }

  @override
  void initState() {
    Future.wait([
      initRegionProviderData(),
    ]);
    getData();

    super.initState();
  }

  @override
  void dispose() {
    provinsiC.dispose();
    kecamatanC.dispose();
    kabupatenC.dispose();
    desaC.dispose();

    nameC.dispose();
    nameFn.dispose();

    phoneNumberC.dispose();
    phoneNumberFn.dispose();

    emailC.dispose();
    emailFn.dispose();

    ktpC.dispose();
    ktpFn.dispose();

    organisasiC.dispose();
    organisasiFn.dispose();

    profesiC.dispose();
    profesiFn.dispose();

    alamatKTPC.dispose();
    alamatKTPFn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.white,
      body: Container(
        decoration: buildBackground(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              buildAppBar(),
              buildBodyContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[4],
          color: ColorResources.white,
        ),
        padding: const EdgeInsets.all(20.0),
        child: buildSubmitButton(),
      ),
    );
  }

  BoxDecoration buildBackground() {
    return const BoxDecoration(color: ColorResources.white);
  }

  Widget buildAppBar() {
    return const CustomAppBar(
      title: 'Personal Data',
      fromHome: true,
    ).buildSliverAppBar(context);
  }

  CustomButton buildSubmitButton() {
    return CustomButton(
      onTap: submit,
      customText: true,
      text: Text(
        getTranslated('NEXT', context),
        style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: ColorResources.white),
      ),
      isBoxShadow: true,
      btnColor: ColorResources.primary,
      isBorderRadius: true,
      sizeBorderRadius: 10.0,
    );
  }

  Widget buildBodyContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.marginSizeLarge),
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            padding: const EdgeInsets.all(
              30.0,
            ),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildTextFields(),
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFields() {
    return Column(
      children: [
        CustomTextFieldV2(
          emptyWarning: "Isi nama",
          controller: nameC,
          hintText: getTranslated('NAME', context),
          textInputType: TextInputType.text,
          focusNode: nameFn,
          textInputAction: TextInputAction.next,
          nextNode: emailFn,
          isBorderRadius: true,
          isEnabled: nameC.text.trim().isEmpty,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi email",
          controller: emailC,
          isEmail: true,
          hintText: "E-mail",
          textInputType: TextInputType.emailAddress,
          focusNode: emailFn,
          textInputAction: TextInputAction.next,
          nextNode: phoneNumberFn,
          isBorderRadius: true,
          isEnabled: emailC.text.trim().isEmpty,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi nomor telepon",
          controller: phoneNumberC,
          maxLength: 13,
          hintText: getTranslated('PHONE_NUMBER', context),
          textInputType: TextInputType.phone,
          focusNode: phoneNumberFn,
          textInputAction: TextInputAction.next,
          isPhoneNumber: true,
          nextNode: ktpFn,
          isBorderRadius: true,
          isEnabled: phoneNumberC.text.trim().isEmpty,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi No KTP",
          maxLength: 16,
          controller: ktpC,
          hintText: 'No KTP',
          isNumber: true,
          textInputType: TextInputType.number,
          focusNode: ktpFn,
          textInputAction: TextInputAction.next,
          nextNode: alamatKTPFn,
          isBorderRadius: true,
          isSuffixIcon: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          maxLines: 5,
          emptyWarning: "Isi Alamat KTP",
          controller: alamatKTPC,
          hintText: 'Alamat KTP',
          textInputType: TextInputType.text,
          focusNode: alamatKTPFn,
          textInputAction: TextInputAction.done,
          isBorderRadius: true,
          isSuffixIcon: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
        RegionDropdown.buildDropdownSection(
          context,
          provinsiC: provinsiC,
          kabupatenC: kabupatenC,
          kecamatanC: kecamatanC,
          desaC: desaC,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi Organisasi",
          controller: organisasiC,
          hintText: 'Organisasi',
          textInputType: TextInputType.text,
          focusNode: organisasiFn,
          textInputAction: TextInputAction.done,
          isBorderRadius: true,
          isSuffixIcon: true,
          isEnabled: organisasiC.text.trim().isEmpty,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi Profesi",
          controller: profesiC,
          hintText: 'Profesi',
          textInputType: TextInputType.text,
          focusNode: profesiFn,
          textInputAction: TextInputAction.done,
          isBorderRadius: true,
          isSuffixIcon: true,
          isEnabled: profesiC.text.trim().isEmpty,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildUploadSelfiePhoto(),
            buildUploadKTPPhoto(),
          ],
        ),
      ],
    );
  }

  Column buildUploadKTPPhoto() {
    return Column(
      children: [
        InkWell(
          onTap: ktpPhoto != null
              ? () {
                  setState(() {
                    ktpPhoto = null;
                  });
                }
              : () {
                  chooseFileKTP();
                },
          child: ktpPhoto != null
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(
                                ktpPhoto!,
                                scale: 1.0,
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.error,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: ColorResources.white,
                            size: Dimensions.iconSizeDefault,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : DottedBorder(
                  strokeWidth: 2.0,
                  dashPattern: const [10, 5],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10.0),
                  color: ColorResources.hintColor,
                  child: const SizedBox(
                    height: 120.0,
                    width: 120.0,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: Dimensions.iconSizeLarge,
                        color: ColorResources.hintColor,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Upload Foto KTP",
          style: robotoRegular.copyWith(
              color: ColorResources.hintColor,
              fontSize: Dimensions.fontSizeLarge),
        ),
      ],
    );
  }

  Column buildUploadSelfiePhoto() {
    return Column(
      children: [
        InkWell(
          onTap: selfiePhoto != null
              ? () {
                  setState(() {
                    selfiePhoto = null;
                  });
                }
              : () {
                  chooseFileSelfie();
                },
          child: selfiePhoto != null
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(
                                selfiePhoto!,
                                scale: 1.0,
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.error,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: ColorResources.white,
                            size: Dimensions.iconSizeDefault,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : DottedBorder(
                  strokeWidth: 2.0,
                  dashPattern: const [10, 5],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10.0),
                  color: ColorResources.hintColor,
                  child: const SizedBox(
                    height: 120.0,
                    width: 120.0,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: Dimensions.iconSizeLarge,
                        color: ColorResources.hintColor,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Upload Foto Selfie",
          style: robotoRegular.copyWith(
              color: ColorResources.hintColor,
              fontSize: Dimensions.fontSizeLarge),
        ),
      ],
    );
  }
}
