import 'package:flutter/material.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/dropdown/dropdown.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import '../../basewidgets/snackbar/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  final String? email;
  final String? name;

  const SignUpScreen({Key? key, this.email, this.name}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController organisasiC;
  late TextEditingController profesiC;

  late TextEditingController nameC;
  late FocusNode nameFn;

  late TextEditingController phoneNumberC;
  late FocusNode phoneNumberFn;

  late TextEditingController emailC;
  late FocusNode emailFn;

  late TextEditingController referralC;
  late FocusNode referralFn;

  late TextEditingController passC;
  late FocusNode passFn;

  late TextEditingController passConfirmC;
  late FocusNode passConfirmFn;

  dynamic currentBackPressTime;

  Future<void> register() async {
    String name = nameC.text.trim();
    String phoneNumber = phoneNumberC.text.trim();
    String email = emailC.text.trim();
    String organisasi = organisasiC.text.trim();
    String profesi = profesiC.text.trim();
    String pass = passC.text.trim();
    String passConfirm = passConfirmC.text.trim();
    bool emailValid = RegExp(r"[a-zA-Z0-9_]+@[a-zA-Z]+\.(com|net|org)$")
        .hasMatch(email.trim());

    if (formKey.currentState!.validate()) {
      if (!emailValid) {
        ShowSnackbar.snackbar(
            context,
            getTranslated("INVALID_FORMAT_EMAIL", context),
            "",
            ColorResources.error);
        emailFn.requestFocus();
        return;
      }
      if (organisasi == "" || organisasi.isEmpty) {
        ShowSnackbar.snackbar(context, 'Pilih Organisasi Terlebih Dahulu', "",
            ColorResources.error);
        return;
      }
      if (profesi == "" || profesi.isEmpty) {
        ShowSnackbar.snackbar(
            context, 'Pilih Profesi Terlebih Dahulu', "", ColorResources.error);
        return;
      }
      if (passConfirm.trim() != pass.trim()) {
        ShowSnackbar.snackbar(
            context,
            getTranslated('PASSWORD_CONFIRM_DOES_NOT_MATCH', context),
            "",
            ColorResources.error);
        passConfirmFn.requestFocus();
        return;
      }

      SharedPrefs.writeRegisterData(
        fullname: name,
        email: email,
        password: pass,
        phone: phoneNumber,
        organization: organisasi,
        job: profesi,
        referral: referralC.text,
      );

      await context.read<AuthProvider>().register(context);
    }
  }

  void getData() {
    referralC = TextEditingController();
    referralFn = FocusNode();

    organisasiC = TextEditingController();
    profesiC = TextEditingController();

    nameC = TextEditingController();
    nameFn = FocusNode();

    phoneNumberC = TextEditingController();
    phoneNumberFn = FocusNode();

    emailC = TextEditingController();
    emailFn = FocusNode();

    passC = TextEditingController();
    passFn = FocusNode();

    passConfirmC = TextEditingController();
    passConfirmFn = FocusNode();

    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      if (mounted) {
        nameC = TextEditingController(
            text: SharedPrefs.getRegFullname() ?? widget.name);
        phoneNumberC = TextEditingController(text: SharedPrefs.getRegPhone());
        emailC = TextEditingController(
            text: SharedPrefs.getRegEmail() ?? widget.email);
        passC = TextEditingController(text: SharedPrefs.getRegPassword());
        setState(() {});
      }
    });
  }

  Future<void> fetchJobsAndOrganizations() async {
    debugPrint('fetched!');
    if (mounted) {
      context.read<AuthProvider>().getJobs(context);
    }
    if (mounted) {
      context.read<AuthProvider>().getOrganizations(context);
    }
  }

  @override
  void initState() {
    Future.wait([
      fetchJobsAndOrganizations(),
    ]);
    getData();

    super.initState();
  }

  @override
  void dispose() {
    organisasiC.dispose();
    profesiC.dispose();

    nameC.dispose();
    nameFn.dispose();

    phoneNumberC.dispose();
    phoneNumberFn.dispose();

    emailC.dispose();
    emailFn.dispose();

    passC.dispose();
    passFn.dispose();

    passConfirmC.dispose();
    passConfirmFn.dispose();

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: buildRegisterButton(),
      ),
    );
  }

  BoxDecoration buildBackground() {
    return const BoxDecoration(color: ColorResources.white);
  }

  Widget buildAppBar() {
    return const CustomAppBar(
      title: 'Daftar Akun',
    ).buildSliverAppBar(context);
  }

  CustomButton buildRegisterButton() {
    return CustomButton(
      isLoading:
          context.watch<AuthProvider>().registerStatus == RegisterStatus.loading
              ? true
              : false,
      onTap: register,
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
          nextNode: passFn,
          isBorderRadius: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Masukan referral (Opsional)",
          controller: referralC,
          isEmail: true,
          hintText: "Referral (Opsional)",
          textInputType: TextInputType.text,
          focusNode: referralFn,
          textInputAction: TextInputAction.next,
          nextNode: phoneNumberFn,
          isBorderRadius: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomDropdown.buildDropdownSearchOrganization(
          dropdownC: organisasiC,
          searchHint: 'Cari Organisasi',
          label: 'Organisasi',
          options: context.read<AuthProvider>().organizations ?? [],
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomDropdown.buildDropdownSearchJob(
          dropdownC: profesiC,
          searchHint: 'Cari Profesi',
          label: 'Profesi',
          options: context.read<AuthProvider>().jobs ?? [],
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi password",
          maxLength: 8,
          controller: passC,
          hintText: getTranslated('PASSWORD', context),
          textInputType: TextInputType.text,
          focusNode: passFn,
          textInputAction: TextInputAction.next,
          nextNode: passConfirmFn,
          isBorderRadius: true,
          isPassword: true,
          isSuffixIcon: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
        CustomTextFieldV2(
          emptyWarning: "Isi konfirmasi password",
          maxLength: 8,
          controller: passConfirmC,
          hintText: getTranslated('PASSWORD_CONFIRM', context),
          textInputType: TextInputType.text,
          focusNode: passConfirmFn,
          textInputAction: TextInputAction.done,
          isBorderRadius: true,
          isPassword: true,
          isSuffixIcon: true,
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
