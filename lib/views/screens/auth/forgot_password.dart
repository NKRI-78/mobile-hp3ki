import 'package:flutter/material.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailC;
  late FocusNode emailFn;

  @override 
  void initState() {
    super.initState();

    emailC = TextEditingController();
    emailFn = FocusNode();
  }
  
  @override 
  void dispose() {
    emailC.dispose();
    emailFn.dispose();

    super.dispose();
  }

  Future<void> submit() async {
    String email = emailC.text.trim();
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailC.text);
    if(formKey.currentState!.validate()){
      if(!emailValid) {
        emailFn.requestFocus();
        ShowSnackbar.snackbar(getTranslated("INVALID_FORMAT_EMAIL", context), "", ColorResources.error);
        return;
      }
      await context.read<AuthProvider>().forgetPassword(context, email);   
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBodyContent()
    );
  }

  SafeArea buildBodyContent() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: buildBackgroundDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only( top: 15.0, left: 25.0, right: 25.0 ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildEmailTextField(context),
                            buildSubmitButton(context),
                          ],
                        )
                      ),
                    ],
                  )
                ),
              ),
            ],
          );
        },
      )
    );
  }

  BoxDecoration buildBackgroundDecoration() {
    return const BoxDecoration(
      color: ColorResources.white,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return const CustomAppBar(title: 'Lupa Kata Sandi').buildAppBar(context);
  }

  Widget buildEmailTextField(BuildContext context) {
    return Form(
      key: formKey,
      child: CustomTextFieldV2(
        controller: emailC,
        isEmail: true,
        hintText: 'Masukkan email anda',
        textInputType: TextInputType.emailAddress,
        focusNode: emailFn,
        emptyWarning: 'Isi Email Anda',
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Container buildSubmitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      child: CustomButton(
        onTap: submit,
        isLoading: context.watch<AuthProvider>().forgetPasswordStatus == ForgetPasswordStatus.loading 
          ? true
          : false,
        isBorderRadius: true,
        customText: true,
        text: Text('Submit',
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: ColorResources.white
          ),
        ),
        btnColor: ColorResources.primary,
        sizeBorderRadius: 10.0,
        isBoxShadow: true,
      )
    );
  }
}