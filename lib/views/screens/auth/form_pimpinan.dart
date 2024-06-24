import 'package:flutter/material.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/region_dropdown/region_dropdown.dart';
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

class FormPimpinanScreen extends StatefulWidget {
  
  const FormPimpinanScreen({ Key? key}) : super(key: key);

  @override
  State<FormPimpinanScreen> createState() => _FormPimpinanScreenState();
}

class _FormPimpinanScreenState extends State<FormPimpinanScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController provinsiC;
  late TextEditingController kecamatanC;
  late TextEditingController kabupatenC;
  late TextEditingController desaC;
  late TextEditingController bentukUsahaC;
  late TextEditingController klasifikasiUsahaC;

  late TextEditingController namaLembagaC;
  late FocusNode namaLembagaFn;

  late TextEditingController alamatLembagaC;
  late FocusNode alamatLembagaFn;

  dynamic currentBackPressTime;

  Future<void> submit() async {
    String namaLembaga = namaLembagaC.text.trim();
    String alamatLembaga = alamatLembagaC.text.trim();
    String provinsi = provinsiC.text.trim();
    String kecamatan = kecamatanC.text.trim();
    String kabupaten = kabupatenC.text.trim();
    String desa = desaC.text.trim();
    String bentukUsaha = bentukUsahaC.text.trim();
    String klasifikasiUsaha = klasifikasiUsahaC.text.trim();

    if(provinsi == "" || provinsi.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Provinsi Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if(kabupaten == "" || kabupaten.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Kabupaten Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if(desa == "" || desa.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Desa Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if(kecamatan == "" || kecamatan.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Kecamatan Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if(klasifikasiUsaha == "" || klasifikasiUsaha.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Klasifikasi Usaha Terlebih Dahulu', "", ColorResources.error);
      return;
    }
    if(bentukUsaha == "" || bentukUsaha.isEmpty) {
      ShowSnackbar.snackbar(context, 'Pilih Bentuk Usaha Terlebih Dahulu', "", ColorResources.error);
      return;
    }

    if (formKey.currentState!.validate()) {

      SharedPrefs.writeOtherJobData(
        nameInstance: namaLembaga,
        addressInstance: alamatLembaga,
        jobProvinceId: provinsi,
        jobProvince: context.read<RegionDropdownProvider>().currentProvince!,
        jobCityId: kabupaten,
        jobCity: context.read<RegionDropdownProvider>().currentCity!,
        jobDistrictId: kecamatan,
        jobDistrict: context.read<RegionDropdownProvider>().currentDistrict!,
        jobSubdistrictId: desa,
        jobSubdistrict: context.read<RegionDropdownProvider>().currentSubdistrict!,
        formOfBusiness: bentukUsaha,
        formOfClassification: klasifikasiUsaha,
      );
      
      await context.read<ProfileProvider>().fulfillJobData(context);
    }
  }

  void getData() {
    provinsiC = context.read<RegionDropdownProvider>().currentProvinceIdC;
    kabupatenC = context.read<RegionDropdownProvider>().currentCityIdC;
    kecamatanC = context.read<RegionDropdownProvider>().currentDistrictIdC;
    desaC = context.read<RegionDropdownProvider>().currentSubdistrictIdC;
    bentukUsahaC = TextEditingController();
    klasifikasiUsahaC = TextEditingController();
    
    namaLembagaC = TextEditingController();
    namaLembagaFn = FocusNode();
    
    alamatLembagaC = TextEditingController();
    alamatLembagaFn = FocusNode();
  }

  Future<void> fetchAdditionalList() async {
    if(mounted) {
      context.read<RegionDropdownProvider>().initRegion(context);
    }
    if(mounted){
      context.read<ProfileProvider>().getBusinessList(context);
    }
    if(mounted){
      context.read<ProfileProvider>().getClassificationList(context);
    }
  }

  @override
  void initState() {
    Future.wait([fetchAdditionalList(),]);
    getData();

    super.initState();
  }

  @override
  void dispose() {
    provinsiC.dispose();
    kecamatanC.dispose();
    kabupatenC.dispose();
    desaC.dispose();
    bentukUsahaC.dispose();
    klasifikasiUsahaC.dispose();

    namaLembagaC.dispose();
    namaLembagaFn.dispose();
    
    alamatLembagaC.dispose();
    alamatLembagaFn.dispose();
    
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
        child: buildRegisterButton(),
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
      title: 'Data Pimpinan',
    ).buildSliverAppBar(context);
  }

  CustomButton buildRegisterButton() {
    return CustomButton(
      isLoading: context.watch<ProfileProvider>().fulfillJobDataStatus == FulfillJobDataStatus.loading
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
      children: [
        CustomTextFieldV2(
          emptyWarning: "Isi Nama Lembaga/Instansi",
          controller: namaLembagaC,
          hintText: 'Nama Lembaga/Instansi',
          textInputType: TextInputType.text, 
          focusNode: namaLembagaFn, 
          textInputAction: TextInputAction.next,
          nextNode: alamatLembagaFn,
          isBorderRadius: true,
        ),
        const SizedBox(height: 15.0,),
        CustomTextFieldV2(
          maxLines: 5,
          emptyWarning: "Isi Alamat Lembaga/Instansi",
          controller: alamatLembagaC,
          hintText: 'Alamat Lembaga/Instansi',
          textInputType: TextInputType.text, 
          focusNode: alamatLembagaFn, 
          textInputAction: TextInputAction.done,
          isBorderRadius: true,
          isSuffixIcon: true,
        ),
        const SizedBox(height: 15.0,),
        RegionDropdown.buildDropdownSection(
          context,
          provinsiC: provinsiC,
          kabupatenC: kabupatenC,
          kecamatanC: kecamatanC,
          desaC: desaC,
        ),
        const SizedBox(height: 15.0,),
        CustomDropdown.buildDropdownSearchBusiness(
          dropdownC: bentukUsahaC,
          searchHint: 'Cari Bentuk Usaha',
          label: 'Bentuk Usaha',
          options: context.read<ProfileProvider>().businessList ?? [],
        ),
        const SizedBox(height: 15.0,),
        CustomDropdown.buildDropdownSearchClassification(
          dropdownC: klasifikasiUsahaC,
          searchHint: 'Cari Klasifikasi Usaha',
          label: 'Klasifikasi Usaha',
          options: context.read<ProfileProvider>().classificationList ?? [],
        ),
        const SizedBox(height: 15.0,),
      ],
    );
  }
}