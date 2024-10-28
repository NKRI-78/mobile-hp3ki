import 'package:flutter/material.dart';

import 'package:hp3ki/providers/profile/profile.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({ Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  late TextEditingController namaC;
  late FocusNode namaFn;

  late TextEditingController alamatC;
  late FocusNode alamatFn;

  dynamic currentBackPressTime;

  Future<void> submit() async {
    String nama = namaC.text.trim();
    String alamat = alamatC.text.trim();

    if (formKey.currentState!.validate()) {
        context.read<ProfileProvider>().updateProfileNameOrAddress(context, name: nama, address: alamat);
      }
  }

  @override
  void initState() {
    namaC = TextEditingController(text: context.read<ProfileProvider>().user?.fullname);
    namaFn = FocusNode();
    
    alamatC = TextEditingController(text: context.read<ProfileProvider>().user?.addressKtp);
    alamatFn = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    namaC.dispose();
    namaFn.dispose();
    
    alamatC.dispose();
    alamatFn.dispose();
    
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
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
    return const BoxDecoration(
      color: ColorResources.white
    );
  }

  Widget buildAppBar() {
    return const CustomAppBar(
      title: 'Edit Profile',
    ).buildSliverAppBar(context);
  }

  CustomButton buildSubmitButton() {
    return CustomButton(
      isLoading: context.watch<ProfileProvider>().updateProfileStatus == UpdateProfileStatus.loading
        ? true : false,
      onTap: submit,
      customText: true,
      text: Text(
        getTranslated('NEXT', context),
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: ColorResources.white
        ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            padding: const EdgeInsets.all(30.0,),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildTextFields(),
                      const SizedBox(height: 35,),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          label: 'Nama',
          controller: namaC,
          currentNode: namaFn,
          example: 'Bambing',
          nextNode: alamatFn,
        ),
        const SizedBox(height: 15.0,),
        buildTextField(
          label: 'alamat',
          controller: alamatC,
          currentNode: alamatFn,
          example: 'Jalan Abcde',
          nextNode: alamatFn,
          maxLines: 5,
        ),
        const SizedBox(height: 15.0,),
      ],
    );
  }

  Column buildTextField({
    required String label,
    required String example,
    required TextEditingController controller,
    required FocusNode currentNode,
    required FocusNode nextNode,
    int maxLines = 1,
  }) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5,),
          CustomTextFieldV2(
            maxLines: maxLines,
            emptyWarning: "Isi $label",
            controller: controller,
            hintText: 'Contoh: $example',
            textInputType: TextInputType.text, 
            focusNode: currentNode, 
            textInputAction: TextInputAction.next,
            nextNode: nextNode,
            isBorderRadius: true,
          ),
        ],
      );
  }
}