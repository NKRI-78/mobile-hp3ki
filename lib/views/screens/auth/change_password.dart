import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/providers/auth/auth.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isFromForget;

  const ChangePasswordScreen({ Key? key, required this.isFromForget }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController oldPassC;
  late FocusNode oldPassFn;

  late TextEditingController newPassC;
  late FocusNode newPassFn;

  late TextEditingController newPassConfirmC;
  late FocusNode newPassConfirmFn;

  @override 
  void initState() {
    super.initState();

    oldPassC = TextEditingController();
    oldPassFn = FocusNode();

    newPassC = TextEditingController();
    newPassFn = FocusNode();
    
    newPassConfirmC = TextEditingController();
    newPassConfirmFn = FocusNode();
  }
  
  @override 
  void dispose() {
    oldPassC.dispose();
    oldPassFn.dispose();
    
    newPassC.dispose();
    newPassFn.dispose();

    newPassConfirmC.dispose();
    newPassConfirmFn.dispose();

    super.dispose();
  }

  Future<void> submit() async {
    String oldPass = oldPassC.text;
    String newPass = newPassC.text;
    String newPassConfirm = newPassConfirmC.text;
    if(formKey.currentState!.validate()){
      
      if(newPassConfirm.trim() != newPass.trim() && newPass.trim() != newPassConfirm.trim()) {
        ShowSnackbar.snackbar(context, getTranslated("PASSWORD_DID_NOT_MATCH", context), "", ColorResources.error);
        return;
      }
      
      if(oldPass.trim().length < 8) {
        oldPassFn.requestFocus();
        ShowSnackbar.snackbar(context, getTranslated("OLD_PASSWORD_8_REQUIRED", context), "", ColorResources.error);
        return;
      }

      if(newPass.trim().length < 8) {
        newPassFn.requestFocus();
        ShowSnackbar.snackbar(context, getTranslated("NEW_PASSWORD_8_REQUIRED", context), "", ColorResources.error);
        return;
      }
      
      if(newPassConfirm.trim().length < 8) {
        newPassConfirmFn.requestFocus();
        ShowSnackbar.snackbar(context, getTranslated("NEW_PASSWORD_CONFIRM_8_REQUIRED", context), "", ColorResources.error);
        return;
      }

      if(newPass.trim() != newPassConfirm.trim()) {
        ShowSnackbar.snackbar(context, getTranslated("NEW_PASSWORD_CONFIRM_DID_NOT_MATCH", context), "", ColorResources.error);
        return;
      }

      if(oldPass.trim() == newPass.trim()) {
        ShowSnackbar.snackbar(context, getTranslated("NEW_PASSWORD_DIFFERENT_OLD_PASSWORD", context), "", ColorResources.error);
        return;
      }

      widget.isFromForget == true
      ? await context.read<AuthProvider>().setNewPassword(context, oldPass, newPass)
      : await context.read<AuthProvider>().changePassword(context, oldPass, newPass);   
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
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildPasswordTextField(context),
                              const SizedBox(height: 10,),
                              buildNewPasswordTextField(context),
                              const SizedBox(height: 10,),
                              buildNewPasswordConfirmTextField(context),
                              const SizedBox(height: 10,),
                              buildSubmitButton(context),
                            ],
                          ),
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
    return CustomAppBar(title: widget.isFromForget == true
      ? "Buat Kata Sandi Baru"
      : getTranslated("CHANGE_PASSWORD", context),
    ).buildAppBar(context);
  }

  Widget buildPasswordTextField(BuildContext context) {
    return CustomTextFieldV2(
      maxLength: 8,
      controller: oldPassC,
      emptyWarning: widget.isFromForget == true
        ? 'Kode Verifikasi Harus Diisi'
        : getTranslated("OLD_PASSWORD_REQUIRED", context),
      hintText: widget.isFromForget == true 
        ? "Kode Verifikasi"
        : getTranslated('OLD_PASSWORD', context),
      textInputType: TextInputType.text,
      isPassword: widget.isFromForget == true ? false : true,
      isSuffixIcon: true,
      focusNode: oldPassFn,
      textInputAction: TextInputAction.next,
      nextNode: newPassFn,
      isBorderRadius: true,
    );
  }

  Widget buildNewPasswordTextField(BuildContext context) {
    return CustomTextFieldV2(
      maxLength: 8,
      controller: newPassC,
      hintText: 'Kata Sandi Baru',
      emptyWarning: 'Kata Sandi Baru Harus Diisi',
      textInputType: TextInputType.text,
      isPassword: true,
      isSuffixIcon: true,
      focusNode: newPassFn,
      textInputAction: TextInputAction.next,
      nextNode: newPassConfirmFn,
      isBorderRadius: true,
    );
  }

  Widget buildNewPasswordConfirmTextField(BuildContext context) {
    return CustomTextFieldV2(
      maxLength: 8,
      controller: newPassConfirmC,
      hintText: 'Konfirmasi Kata Sandi Baru',
      emptyWarning: 'Konfirmasi Kata Sandi Baru Harus Diisi',
      textInputType: TextInputType.text,
      isPassword: true,
      isSuffixIcon: true,
      focusNode: newPassConfirmFn,
      textInputAction: TextInputAction.done,
      isBorderRadius: true,
    );
  }

  Container buildSubmitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      child: CustomButton(
        onTap: submit,
        isLoading: context.watch<AuthProvider>().changePasswordStatus == ChangePasswordStatus.loading 
        ? true
        : false,
        isBorderRadius: true,
        customText: true,
        text: Text('Submit',
          style: poppinsRegular.copyWith(
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