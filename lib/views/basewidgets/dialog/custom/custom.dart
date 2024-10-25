import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/views/screens/maintain/maintain.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/screens/auth/form_personal.dart';

class CustomDialog {
  static showFulfillData(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => false,
          child: _buildFulfillDialog(context),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        return BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 4 * a1.value, sigmaY: 4 * a1.value),
            child: FadeTransition(opacity: a1, child: child));
      },
    );
  }

  static AwesomeDialog buildPaymentSuccessDialog(BuildContext context,
      [String? text]) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      customHeader: Image.asset(
        'assets/images/auth/Success.png',
        height: 160.0,
        width: 160.0,
        fit: BoxFit.cover,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          text ??
              "Terimakasih sudah melakukan transaksi di HP3KI Mobile Apps, detail pembayaranmu tersimpan di notifikasi.",
          style: robotoRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeLarge,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      btnOkText: "Beranda",
      btnOkColor: ColorResources.primary,
      btnOkOnPress: () => NS.pushReplacement(context, const DashboardScreen()),
    )..show();
  }

  static AlertDialog _buildFulfillDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Center(
        child: Image.asset(
          'assets/images/avatar/avatar-fulfill.png',
          height: 80,
          width: 80,
          fit: BoxFit.fill,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lengkapi Data',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: ColorResources.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Anda diwajibkan untuk melengkapi data terlebih dahulu.',
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeLarge,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: ColorResources.black.withOpacity(0.5),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            onTap: () {
              NS.pushUntil(context, const FormPersonalScreen());
            },
            btnColor: ColorResources.primary,
            isBorderRadius: true,
            sizeBorderRadius: 30.0,
            customText: true,
            text: Text(
              'Ok',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: ColorResources.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static AwesomeDialog showWarning(BuildContext context,
      {required String warning}) {
    return AwesomeDialog(
        autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.warning,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Peringatan',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                warning,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showWarningMemberNonPlatinum(BuildContext context, {required String warning}) {
    return AwesomeDialog(
        // autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.warning,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {
          NS.push(context, const MaintainScreen());
          // NS.push(context, const UpgradeMemberInquiryV2Screen());
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Peringatan',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                warning,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showError(BuildContext context,
      {required String error}) {
    return AwesomeDialog(
        autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ada Kesalahan',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                error,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showErrorCustom(BuildContext context,
      {String title = '', String message = ''}) {
    return AwesomeDialog(
        autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold),
                ),
              const SizedBox(
                height: 15,
              ),
              Text(
                message,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showForceLogoutError(BuildContext context,
      {required String error}) {
    return AwesomeDialog(
        context: context,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {
          context.read<AuthProvider>().logout(context);
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mohon Maaf',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                error,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showSuccess(BuildContext context,
      {required String msg}) {
    return AwesomeDialog(
        autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Berhasil!',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                msg,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog showUnexpectedError(BuildContext context,
      {required String errorCode}) {
    return AwesomeDialog(
        autoHide: const Duration(seconds: 5),
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        btnOkText: "Ok",
        btnOkColor: ColorResources.secondary,
        btnOkOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ada Kesalahan',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Error tidak terduga dalam aplikasi.',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static AwesomeDialog askLogout(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        btnOkText: "Log Out",
        btnOkColor: Colors.red,
        btnOkOnPress: () {
          context.read<AuthProvider>().logout(context);
        },
        btnCancelText: "Batal",
        btnCancelColor: ColorResources.blueDrawerPrimary,
        btnCancelOnPress: () {},
        customHeader: Image.asset(
          'assets/images/avatar/avatar-logout.png',
          height: 80.0,
          width: 80.0,
          fit: BoxFit.fitWidth,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apakah anda yakin ingin melakukan Log Out?',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ))
      ..show();
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
