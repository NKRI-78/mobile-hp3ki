import 'package:flutter/material.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/screens/about/about.dart';

class AboutMenuScreen extends StatefulWidget {

  const AboutMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutMenuScreen> createState() => _AboutMenuScreenState();
}

class _AboutMenuScreenState extends State<AboutMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: ColorResources.white,
        child: buildBodyContent(),
      ),
    );
  }

  AppBar buildAppBar() {
    return const CustomAppBar(title: 'Tentang HP3KI',).buildAppBar(context);
  }

  Widget buildBodyContent() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: [
          buildAboutMenuContent(),
        ],
      ),
    );
  }

  Widget buildAboutMenuContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildButton(
          buttonText: 'Seputar HP3KI',
          onTap: () => NS.push(context, const AboutScreen(screenIndex: 1,)),
        ),
        const SizedBox(height: 15,),
        buildButton(
          buttonText: 'Visi dan Misi HP3KI',
          onTap: () => NS.push(context, const AboutScreen(screenIndex: 2,)),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }

  Widget buildButton({required String buttonText, required dynamic Function() onTap}) {
    return CustomButton(
          onTap: onTap,
          btnColor: ColorResources.white,
          customText: true,
          text: Text(
            buttonText,
            style: poppinsRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          isBorderRadius: true,
          isBoxShadow: true,
          height: 70,
          isBackgroundImage: true,
          isPrefixIcon: true,
        );
  }
}