import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/views/screens/auth/sign_in.dart';

class OtpScreen extends StatefulWidget {

  const OtpScreen({Key? key}) : super(key: key);

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpC = TextEditingController();
  
  bool loading = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    (() async {
      loading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        context.read<AuthProvider>().changeEmail; 
        context.read<AuthProvider>().changeEmailName = prefs.getString("email_otp")!; 
        loading = false;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Scaffold buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.white,
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBodyContent()
    );
  }

  @override
  void dispose() {
    otpC.dispose();
    
    super.dispose();
  }

  AppBar buildAppBar() {
    return const CustomAppBar(title: 'OTP', fromHome: true).buildAppBar(context);
  }

  Consumer<AuthProvider> buildBodyContent() {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmailVerificationTextTop(context),
              buildEmailVerificationTextBottom(context, authProvider),
              const SizedBox( height: 20.0 ),
              authProvider.changeEmail 
                ? buildOTPForm(context, authProvider)
                : Container(),
              authProvider.changeEmail 
                ? Container() 
                : buildChangeEmailTextFormField(authProvider),
              authProvider.changeEmail 
                ? Container() 
                : buildChangeEmailButtons(context, authProvider), 
              authProvider.whenCompleteCountdown == "start" 
                ? buildCountdownStartContent(authProvider)
                : Container(),
              const SizedBox( height: 5.0, ),
              authProvider.whenCompleteCountdown == "completed" 
                ? buildCountdownCompleteContent(context, authProvider) 
                : Container(),
              buildVerifyButton(authProvider, context),
              const SizedBox( height: 10.0, ),
              buildBackButton(context),
              buildChangeEmailButton(context, authProvider),
            ],
          ),
        );
      },
  );
  }

  Padding buildEmailVerificationTextTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(getTranslated('EMAIL_VERIFICATION', context),
        style: robotoRegular.copyWith(
          fontWeight: FontWeight.w600, 
          fontSize: Dimensions.fontSizeDefault
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding buildEmailVerificationTextBottom(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: RichText(
        text: TextSpan(
          text: 'Periksa alamat email anda ',
          children: [
            TextSpan(
              text: loading ? "..." : " ${authProvider.changeEmailName}",
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.fontSizeDefault
              )
            ),
          ],
          style: robotoRegular.copyWith(
            color: ColorResources.black, 
            fontSize: Dimensions.fontSizeDefault
          )
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Form buildOTPForm(BuildContext context, AuthProvider authProvider) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
        child: PinCodeTextField(
          appContext: context,
          backgroundColor: Colors.transparent,
          pastedTextStyle: robotoRegular.copyWith(
            color: ColorResources.success,
            fontSize: Dimensions.fontSizeDefault
          ),
          textStyle: robotoRegular,
          length: 4,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            inactiveColor: ColorResources.dimGrey,
            inactiveFillColor: ColorResources.white,
            selectedFillColor: ColorResources.white,
            activeFillColor: ColorResources.white,
            selectedColor: Colors.black,
            activeColor: ColorResources.black,
            borderWidth: 1.5,
            fieldHeight: 50.0,
            fieldWidth: 50.0,
          ),
          cursorColor: ColorResources.primary,
          animationDuration: const Duration(milliseconds: 100),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: (String val) {
            authProvider.otpCompleted(val);
          },
          onChanged: (String val) {

          },
          beforeTextPaste: (text) {
            return true;
          },
        )
      ),
    );
  }

  Container buildChangeEmailTextFormField(AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
      child: TextFormField(
        textCapitalization: TextCapitalization.none,
        onChanged: (val) {
          authProvider.emailCustomChange(val);
        },
        initialValue: authProvider.changeEmailName,
        decoration: InputDecoration(
          fillColor: ColorResources.greyLightPrimary.withOpacity(0.5),
          filled: true,
          hintText: authProvider.changeEmailName,
          hintStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16.0),
        ),
        keyboardType: TextInputType.emailAddress,
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault
        )
      ),
    );
  }

  Container buildChangeEmailButtons(BuildContext context, AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
              width: double.infinity,
              height: 50.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: ColorResources.primary,
                    width: 1.0
                  )
                ),
                  backgroundColor: ColorResources.white,
                ),
                child: Text(getTranslated("CANCEL", context),
                  style: robotoRegular.copyWith(
                    color: ColorResources.primary,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  )
                ),
                onPressed: () {
                  authProvider.cancelCustomEmail();
                }
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              width: double.infinity,
              height: 50.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: ColorResources.secondary,
                    width: 1.0
                  )
                ),
                  backgroundColor: ColorResources.white,
                ),
                child: 
                authProvider.applyChangeEmailOtpStatus == ApplyChangeEmailOtpStatus.loading 
                ? const SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primary),
                    ),
                  ) 
                : Text('Submit',
                  style: robotoRegular.copyWith(
                    color: ColorResources.secondary,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  )
                ),
                onPressed: () {
                  authProvider.applyChangeEmailOtp(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildCountdownStartContent(AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35.0),
      alignment: Alignment.centerRight,
      child: CircularCountDownTimer(
        duration: 120,
        initialDuration: 0,
        width: 40.0,
        height: 40.0,
        ringColor: Colors.transparent,
        ringGradient: null,
        fillColor: ColorResources.primary.withOpacity(0.4),
        fillGradient: null,
        backgroundColor: ColorResources.primary,
        backgroundGradient: null,
        strokeWidth: 10.0,
        strokeCap: StrokeCap.round,
        textStyle: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: ColorResources.white,
          fontWeight: FontWeight.w600
        ),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
        },
        onComplete: () {
          authProvider.completeCountDown();
        },
      ),
    );
  }

  Row buildCountdownCompleteContent(BuildContext context, AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(getTranslated("DID_NOT_RECEIVE_CODE", context),
          style: robotoRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeDefault
          ),
        ),
        TextButton(
          onPressed: () => authProvider.resendOtpCall(context),
          child: authProvider.resendOtpStatus == ResendOtpStatus.loading 
          ? const SizedBox(
            width: 12.0,
            height: 12.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primary),
            ),
          )
          : Text(getTranslated("RESEND", context),
            style: robotoRegular.copyWith(
              color: ColorResources.primary,
              fontSize: Dimensions.fontSizeDefault
            ),
          )
        )
      ],
    );
  }

  Container buildVerifyButton(AuthProvider authProvider, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      width: double.infinity,
      height: 50.0,
      child: CustomButton(
        onTap: () {
          if(authProvider.otp!.trim().isEmpty || authProvider.otp!.trim() == "") {
            ShowSnackbar.snackbar(context, 'Isi OTP Terlebih dahulu!', '', ColorResources.error);
            return;
          } else if (authProvider.otp!.trim().length > 1 && authProvider.otp!.trim().length < 4) {
            ShowSnackbar.snackbar(context, 'Lengkapi OTP anda!', '', ColorResources.error);
            return;
          } else {
            authProvider.verifyOtp(context);
          }
        },
        isLoading: context.watch<AuthProvider>().verifyOtpStatus == VerifyOtpStatus.loading ? true : false,
        customText: true,
        text: Text(
          getTranslated('VERIFY', context),
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: ColorResources.white
          ),
        ),
        btnColor: ColorResources.secondary,
        isBorderRadius: true,
        sizeBorderRadius: 10.0,
      ),
    );
  }

  Container buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextButton(
        child: Text(getTranslated("BACK", context),
          style: robotoRegular.copyWith(
            color: ColorResources.primary,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600
          )
        ),
        onPressed: () {
          NS.pushReplacement(context, const SignInScreen());
        } 
      ),
    );
  }

  Container buildChangeEmailButton(BuildContext context, AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextButton(
        child: Text(getTranslated("CHANGE_EMAIL", context),
          style: robotoRegular.copyWith(
            color: ColorResources.primary,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600
          )
        ),
        onPressed: () {
          authProvider.changeEmailCustom();
        },
      ),
    );
  }
}
