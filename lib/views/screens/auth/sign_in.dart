import 'dart:io';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/screens/auth/forgot_password.dart';
import 'package:hp3ki/views/screens/auth/sign_up.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/views/screens/connection/connection.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ScrollController scrollC;

  late TextEditingController emailOrPhoneC;
  late FocusNode emailOrPhoneFn;

  late TextEditingController passC;
  late FocusNode passFn;

  dynamic currentBackPressTime;

  Future<bool> willPopScope() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowSnackbar.snackbar(getTranslated("PRESS_TWICE_BACK", context),
          "", ColorResources.black);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  Future<void> submit() async {
    String emailOrPhone = emailOrPhoneC.text.trim();
    String pass = passC.text.trim();
    if (formKey.currentState!.validate()) {
      context.read<AuthProvider>().login(context, emailOrPhone, pass);
    }
  }

  Future<void> getData() async {
    if (mounted) {
      await Permission.notification.request();
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
  }

  @override
  void initState() {
    scrollC = ScrollController();

    emailOrPhoneC = TextEditingController();
    emailOrPhoneFn = FocusNode();

    passC = TextEditingController();
    passFn = FocusNode();

    Future.delayed(const Duration(seconds: 2), () {
      getData();
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollC.dispose();

    emailOrPhoneC.dispose();
    emailOrPhoneFn.dispose();

    passC.dispose();
    passFn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(builder: (BuildContext context, InternetProvider internetProvider, Widget? child) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: willPopScope,
        child: Scaffold(
          backgroundColor: ColorResources.transparent,
          body: internetProvider.internetStatus == InternetStatus.disconnected
          ? const NoConnectionScreen()
          : buildConnectionAvailableContent(context),
        ),
      );
    });
  }
  GestureDetector buildConnectionAvailableContent(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
      }),
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: double.infinity,
          decoration: buildBackgroundImage(),
          child: buildBodyContent(),
        ),
      ),
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
      backgroundBlendMode: BlendMode.darken,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ColorResources.black, Color(0xff0B1741)]
      ),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/background/bg.png')
      ),
    );
  }

  Widget buildBodyContent() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(45.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/images/logo/logo.png',
              height: 180,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 150,
          child: Image.asset('assets/images/auth/rectangle.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * .70,
            width: MediaQuery.sizeOf(context).width,
          )
        ),
        Positioned(
          top: 300.0,
          left: 30.0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadingText(),
              const SizedBox(
                height: 15,
              ),
              buildInputForm(),
              const SizedBox(
                height: 15,
              ),
              if (Platform.isAndroid) buildLoginSocialMediaButton(),
              const SizedBox(
                height: 25,
              ),
              buildTextOptions()
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * .05,
            left: 130.0,
            right: 130.0,
          ),
          child: Align(
            alignment: Alignment.bottomCenter, child: buildLoginButton()
          ),
        ),
      ],
    );
  }

  Column buildHeadingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang di',
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              'HP3KI',
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Mobile',
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
                fontWeight: FontWeight.bold,
                color: const Color(0xffDF0C0C),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Login terlebih dahulu untuk masuk',
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ],
    );
  }

  Column buildTextOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            NS.push(context, const SignUpScreen());
          },
          child: Row(
            children: [
              Text(
                'Belum punya akun ? ',
                style: poppinsRegular.copyWith(
                  color: ColorResources.hintColor,
                ),
              ),
              Text(
                ' Daftar Disini',
                style: poppinsRegular.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            NS.push(context, const ForgotPasswordScreen());
          },
          child: Text(
            'Lupa Password?',
            style: poppinsRegular.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox buildLoginSocialMediaButton() {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          CustomButton(
            isLoading: context.watch<AuthProvider>().loginGoogleStatus ==
                    LoginGoogleStatus.loading
                ? true
                : false,
            loadingColor: ColorResources.primary,
            onTap: () {
              context.read<AuthProvider>().loginWithGoogle(context);
            },
            btnColor: ColorResources.white,
            isBoxShadow: true,
            isBorderRadius: true,
            sizeBorderRadius: 30.0,
            customText: true,
            text: Row(
              children: [
                Image.asset(
                  'assets/images/auth/icon-google.png',
                  height: Dimensions.iconSizeDefault,
                  width: Dimensions.iconSizeDefault,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Masuk dengan Google',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: ColorResources.greyDarkPrimary,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return CustomButton(
      isLoading:
          context.watch<AuthProvider>().loginStatus == LoginStatus.loading
              ? true
              : false,
      onTap: () {
        submit();
      },
      height: 70,
      customText: true,
      isBoxShadow: true,
      text: Row(
        children: [
          Text(
            'LOGIN',
            style: poppinsRegular.copyWith(
              color: ColorResources.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.fontSizeOverLarge,
            ),
          ),
          buildAnimatedArrow(),
        ],
      ),
      btnColor: Colors.red,
      isBorderRadius: true,
      sizeBorderRadius: 40.0,
    );
  }

  Widget buildAnimatedArrow() {
    return GestureDetector(
      onTap: submit,
      child: CustomAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 15.0),
        control: Control.mirror,
        curve: Curves.elasticInOut,
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: child,
          );
        },
        child: const Icon(
          Icons.arrow_forward,
          color: ColorResources.white,
          size: Dimensions.iconSizeLarge,
        ),
      ),
    );
  }

  Widget buildInputForm() {
    return SizedBox(
      width: 300,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              isEmail: true,
              controller: emailOrPhoneC,
              hintText: 'Email atau Nomor Telepon',
              emptyWarning: 'Isi Email atau Nomor Telepon!',
              textInputType: TextInputType.text,
              focusNode: emailOrPhoneFn,
              textInputAction: TextInputAction.next,
              nextNode: passFn,
              isPrefixIcon: true,
              prefixIcon: const Icon(
                Icons.person,
                color: ColorResources.hintColor,
                size: Dimensions.iconSizeDefault,
              ),
            ),
            CustomTextField(
              controller: passC,
              hintText: 'Password',
              emptyWarning: 'Isi Password',
              textInputType: TextInputType.text,
              isPassword: true,
              isSuffixIcon: true,
              focusNode: passFn,
              textInputAction: TextInputAction.done,
              isPrefixIcon: true,
              prefixIcon: const Icon(
                Icons.lock,
                color: ColorResources.hintColor,
                size: Dimensions.iconSizeDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
