import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/my_store_create/persentation/widgets/text_form_field_store_cstm.dart';
import 'package:hp3ki/views/screens/shipping_address/persentation/providers/shipping_address_provider.dart';
import 'package:hp3ki/views/screens/shipping_address_add/domain/shipping_address_add_repository.dart';
import 'package:hp3ki/views/screens/shipping_address_add/persentation/providers/shipping_address_add_provider.dart';
import 'package:hp3ki/widgets/custom_select_location.dart';
import 'package:hp3ki/widgets/custom_select_map_location.dart';
import 'package:hp3ki/widgets/keyboard_visibility.dart';
import 'package:provider/provider.dart';

class ShippingAddressAddPage extends StatelessWidget {
  const ShippingAddressAddPage({super.key});

  static Route go() => MaterialPageRoute(
        builder: (_) => const ShippingAddressAddPage(),
      );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ShippingAddressAddProvider(
          repo: ShippingAddressAddRepository(
            client: DioManager.shared.getClient(),
          ),
        ),
      ),
    ], child: const ShippingAddressAddView());
  }
}

class ShippingAddressAddView extends StatefulWidget {
  const ShippingAddressAddView({super.key});

  @override
  State<ShippingAddressAddView> createState() => _ShippingAddressAddViewState();
}

class _ShippingAddressAddViewState extends State<ShippingAddressAddView> {
  TextEditingController pinAddressController = TextEditingController();
  TextEditingController detailAddressController = TextEditingController();
  TextEditingController nameAddressController = TextEditingController();
  TextEditingController labelAddressController = TextEditingController();
  TextEditingController administrationController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  SelectedAdministration? administration;
  LatLng? latLng;

  bool loading = false;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _form,
        child: SizedBox.expand(
          child: KeyboardVisibility(builder: (context, vis, height) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldStoreCstm(
                        controller: nameAddressController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '${getTranslated(
                              "NAME",
                              context,
                            )} ${getTranslated(
                              "ADDRESS",
                              context,
                            )} ${getTranslated(
                              "TXT_REQUIRED",
                              context,
                            )}';
                          }
                          return null;
                        },
                        label: "${getTranslated(
                          "NAME",
                          context,
                        )} ${getTranslated(
                          "ADDRESS",
                          context,
                        )}",
                      ),
                      _divider,
                      TextFormFieldStoreAdressCstm(
                        readOnly: true,
                        controller: administrationController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '${getTranslated(
                              "PROVINCE",
                              context,
                            )}, ${getTranslated(
                              "CITY",
                              context,
                            )}, ${getTranslated(
                              "SUBDISTRICT",
                              context,
                            )} ${getTranslated("TXT_REQUIRED", context)}';
                          }
                          return null;
                        },
                        suffixIcon: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          final adm = await CustomSelectLocationWidget.go(
                              context,
                              administration: administration);
                          if (adm != null) {
                            setState(() {
                              administration = adm;
                              administrationController.text =
                                  "${adm.province.name}\n${adm.city.name}\n${adm.district.name}\n${adm.subDistrict.name}\n${adm.postalCode.name}";
                            });
                          }
                        },
                        label: "${getTranslated(
                          "PROVINCE",
                          context,
                        )}, ${getTranslated(
                          "CITY",
                          context,
                        )}, ${getTranslated(
                          "SUBDISTRICT",
                          context,
                        )}",
                      ),
                      _divider,
                      TextFormFieldStoreAdressCstm(
                        readOnly: true,
                        controller: pinAddressController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '${getTranslated(
                              "TXT_PIN_POINT",
                              context,
                            )} ${getTranslated(
                              "TXT_REQUIRED",
                              context,
                            )}';
                          }
                          return null;
                        },
                        suffixIcon: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          final add =
                              await CustomSelectMapLocationWidget.go(context);
                          if (add != null) {
                            pinAddressController.text = add.address;
                            latLng = add.latLng;
                          }
                        },
                        label:
                            "${getTranslated("TXT_PIN_POINT", context)} ${getTranslated("ADDRESS", context)}",
                      ),
                      _divider,
                      TextFormFieldStoreCstm(
                        minLines: 4,
                        maxLines: 8,
                        controller: detailAddressController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '${getTranslated(
                              "TXT_DETAIL",
                              context,
                            )} ${getTranslated("ADDRESS", context)} ${getTranslated("TXT_REQUIRED", context)}';
                          }
                          return null;
                        },
                        label: "${getTranslated(
                          "TXT_DETAIL",
                          context,
                        )} ${getTranslated(
                          "ADDRESS",
                          context,
                        )}",
                      ),
                      _divider,
                      TextFormFieldStoreCstm(
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '${getTranslated(
                              "TXT_PHONE_NUMBER",
                              context,
                            )} ${getTranslated(
                              "TXT_REQUIRED",
                              context,
                            )}';
                          }
                          return null;
                        },
                        label: getTranslated(
                          "TXT_PHONE_NUMBER",
                          context,
                        ),
                      ),
                      _divider,
                      TextFormFieldStoreCstm(
                        controller: labelAddressController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Label ${getTranslated(
                              "ADDRESS",
                              context,
                            )} ${getTranslated(
                              "TXT_REQUIRED",
                              context,
                            )}';
                          }
                          return null;
                        },
                        label: "Label ${getTranslated(
                          "ADDRESS",
                          context,
                        )} (Rumah, Kantor, etc)",
                      ),
                      _divider,
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    if (!(_form.currentState?.validate() ??
                                        false)) {
                                      return;
                                    }

                                    try {
                                      setState(() {
                                        loading = true;
                                      });
                                      final shippingAddress = context
                                          .read<ShippingAddressProvider>();
                                      await context
                                          .read<ShippingAddressAddProvider>()
                                          .addAddress(
                                              address:
                                                  detailAddressController.text,
                                              postalCode: administration!
                                                  .postalCode.name,
                                              province:
                                                  administration!.province.name,
                                              city: administration!.city.name,
                                              district:
                                                  administration!.district.name,
                                              subDistrict: administration!
                                                  .subDistrict.name,
                                              name: nameAddressController.text,
                                              lat: latLng?.latitude ?? 0,
                                              lng: latLng?.longitude ?? 0,
                                              label:
                                                  labelAddressController.text,
                                              phoneNumber:
                                                  phoneNumberController.text);
                                      shippingAddress.fetchAllShippingAddress();
                                      await GeneralModal.error(context,
                                          msg: getTranslated(
                                              "TXT_SUCCESS", context),
                                          onOk: () {
                                        Navigator.pop(context);
                                      });

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      GeneralModal.error(
                                        context,
                                        msg: e.toString(),
                                      );
                                    } finally {
                                      loading = false;
                                    }
                                  },
                            child: Text(
                                '${getTranslated("TXT_ADD", context)} ${getTranslated("ADDRESS", context)}')),
                      )
                    ],
                  ),
                ),
                if (vis)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Text(
                              getTranslated("TXT_DONE", context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget get _divider => const Divider(
        height: 0.5,
        thickness: 0.5,
      );
}
