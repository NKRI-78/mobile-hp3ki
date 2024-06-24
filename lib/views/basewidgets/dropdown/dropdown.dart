import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/business.dart';
import 'package:hp3ki/data/models/enterpreneurs_additional_data/classifications.dart';
import 'package:hp3ki/data/models/region_dropdown/city.dart';
import 'package:hp3ki/data/models/region_dropdown/district.dart';
import 'package:hp3ki/data/models/region_dropdown/subdisctrict.dart';
import 'package:hp3ki/providers/region_dropdown/region_dropdown.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/textfield/textfield_two.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hp3ki/data/models/region_dropdown/province.dart';
import 'package:hp3ki/data/models/job/job.dart';
import 'package:hp3ki/data/models/organization/organization.dart';
import 'package:hp3ki/utils/color_resources.dart';

class CustomDropdown {
  static InputDecoration? buildDropdownSearchDecoration(
      {required String label}) {
    return InputDecoration(
      fillColor: const Color(0xffFBFBFB),
      filled: true,
      isDense: true,
      alignLabelWithHint: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      labelText: label,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE2E2E2),
            width: 1.0,
          )),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE2E2E2),
            width: 1.0,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: ColorResources.error,
            width: 2.0,
          )),
    );
  }

  static InputDecoration? buildSearchDecoration({required searchHint}) {
    return InputDecoration(
      icon: const Icon(
        Icons.search,
      ),
      hintText: searchHint,
    );
  }

  static DropdownSearch<String> buildDropdownSearch(
      {required List<String> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<String>(
      items: options,
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) {
        dropdownC.text = value!;
      },
    );
  }

  static DropdownSearch<JobData> buildDropdownSearchJob(
      {required List<JobData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<JobData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) {
        SharedPrefs.writeRegJobName(value?.name ?? "...");
        dropdownC.text = value?.id ?? "-";
      },
    );
  }

  static DropdownSearch<BusinessData> buildDropdownSearchBusiness(
      {required List<BusinessData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<BusinessData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) async {
        dropdownC.text = value!.id!;
      },
    );
  }

  static DropdownSearch<ClassificationData> buildDropdownSearchClassification(
      {required List<ClassificationData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<ClassificationData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) async {
        dropdownC.text = value!.id!;
      },
    );
  }

  static DropdownSearch<OrganizationData> buildDropdownSearchOrganization(
      {required List<OrganizationData> options,
      required String label,
      String? searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<OrganizationData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint ?? '') ??
                  const InputDecoration())),
      onChanged: (value) {
        SharedPrefs.writeRegOrgName(value?.name);
        dropdownC.text = value?.id ?? "-";
      },
    );
  }

  static DropdownSearch<ProvinceData> buildDropdownSearchProvince(
      BuildContext context,
      {required List<ProvinceData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<ProvinceData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) async {
        context
            .read<RegionDropdownProvider>()
            .setCurrentProvince(context, name: value?.name ?? "...");
        dropdownC.text = value?.id ?? "-";
      },
    );
  }

  static DropdownSearch<DistrictData> buildDropdownSearchDistrict(
      BuildContext context,
      {required List<DistrictData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<DistrictData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) async {
        context
            .read<RegionDropdownProvider>()
            .setCurrentDistrict(context, name: value?.name ?? "...");
        dropdownC.text = value?.id ?? "-";
      },
    );
  }

  static DropdownSearch<CityData> buildDropdownSearchCity(BuildContext context,
      {required List<CityData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<CityData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) async {
        context
            .read<RegionDropdownProvider>()
            .setCurrentCity(context, name: value?.name ?? "...");
        dropdownC.text = value?.id ?? "-";
      },
    );
  }

  static DropdownSearch<SubdistrictData> buildDropdownSearchSubdistrict(
      BuildContext context,
      {required List<SubdistrictData> options,
      required String label,
      required String searchHint,
      required TextEditingController dropdownC}) {
    return DropdownSearch<SubdistrictData>(
      items: options,
      itemAsString: (item) => item.name ?? "...",
      dropdownSearchDecoration: buildDropdownSearchDecoration(label: label),
      popupProps: PopupProps.dialog(
          showSearchBox: true,
          showSelectedItems: false,
          searchFieldProps: TextFieldProps(
              decoration: buildSearchDecoration(searchHint: searchHint)!)),
      onChanged: (value) {
        context
            .read<RegionDropdownProvider>()
            .setCurrentSubdistrict(name: value?.name ?? "...");
        dropdownC.text = value?.id ?? "-";
      },
    );
  }
}

class RegionDropdown {
  static CustomTextFieldV2 _buildDropdownEmpty({required String label}) {
    return CustomTextFieldV2(
      emptyWarning: "Isi $label",
      controller: TextEditingController(),
      hintText: label,
      textInputType: TextInputType.text,
      focusNode: FocusNode(),
      textInputAction: TextInputAction.done,
      isEnabled: false,
    );
  }

  static Column buildDropdownSection(
    BuildContext context, {
    required TextEditingController provinsiC,
    required TextEditingController kabupatenC,
    required TextEditingController kecamatanC,
    required TextEditingController desaC,
  }) {
    return Column(
      children: [
        CustomDropdown.buildDropdownSearchProvince(
          context,
          dropdownC: provinsiC,
          searchHint: 'Cari Provinsi',
          label: 'Provinsi',
          options: context.read<RegionDropdownProvider>().provinces!,
        ),
        const SizedBox(
          height: 15.0,
        ),
        context.watch<RegionDropdownProvider>().cityStatus == CityStatus.loaded
            ? CustomDropdown.buildDropdownSearchCity(
                context,
                dropdownC: kabupatenC,
                searchHint: 'Cari Kabupaten/Kota',
                label: 'Kabupaten/Kota',
                options: context.read<RegionDropdownProvider>().cities!,
              )
            : _buildDropdownEmpty(label: 'Kabupaten/Kota'),
        const SizedBox(
          height: 15.0,
        ),
        context.watch<RegionDropdownProvider>().districtStatus ==
                DistrictStatus.loaded
            ? CustomDropdown.buildDropdownSearchDistrict(
                context,
                dropdownC: kecamatanC,
                searchHint: 'Cari Kecamatan',
                label: 'Kecamatan',
                options: context.read<RegionDropdownProvider>().districts!,
              )
            : _buildDropdownEmpty(label: 'Kecamatan'),
        const SizedBox(
          height: 15.0,
        ),
        context.watch<RegionDropdownProvider>().subdistrictStatus ==
                SubdistrictStatus.loaded
            ? CustomDropdown.buildDropdownSearchSubdistrict(
                context,
                dropdownC: desaC,
                searchHint: 'Cari Kelurahan/Desa',
                label: 'Kelurahan/Desa',
                options: context.read<RegionDropdownProvider>().subdistricts!,
              )
            : _buildDropdownEmpty(label: 'Kelurahan/Desa'),
      ],
    );
  }
}
