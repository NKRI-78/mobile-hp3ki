// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/my_store/data/my_store_model.dart';
import 'package:hp3ki/views/screens/my_store/persentation/providers/my_store_provider.dart';
import 'package:hp3ki/views/screens/my_store_create/persentation/widgets/text_form_field_store_cstm.dart';
import 'package:hp3ki/views/screens/my_store_edit/domain/my_store_edit_repository.dart';
import 'package:hp3ki/views/screens/my_store_edit/persentation/providers/my_store_edit_provider.dart';
import 'package:hp3ki/widgets/custom_select_location.dart';
import 'package:hp3ki/widgets/custom_select_map_location.dart';
import 'package:hp3ki/widgets/keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';

class MyStoreEditPage extends StatelessWidget {
  const MyStoreEditPage({
    Key? key,
    required this.store,
  }) : super(key: key);

  final MyStoreModel store;

  static Route go(BuildContext ctx, MyStoreModel store) {
    return MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ctx.read<MyStoreProvider>(),
          )
        ],
        child: MyStoreEditPage(
          store: store,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyStoreEditProvider>(
            create: (_) => MyStoreEditProvider(
                repo: MyStoreEditRepository(
                    client: DioManager.shared.getClient())))
      ],
      child: MyStoreEditView(
        store: store,
      ),
    );
  }
}

class MyStoreEditView extends StatefulWidget {
  const MyStoreEditView({super.key, required this.store});

  final MyStoreModel store;

  @override
  State<MyStoreEditView> createState() => _MyStoreEditViewState();
}

class _MyStoreEditViewState extends State<MyStoreEditView> {
  /// region
  String province = '';
  String city = '';
  String district = '';
  String subDistrict = '';
  String postalCode = '';

  TextEditingController administrationController = TextEditingController();

  /// Contact
  TextEditingController nameStoreController = TextEditingController();
  TextEditingController emailStoreController = TextEditingController();
  TextEditingController numberStoreController = TextEditingController();
  TextEditingController descriptionStoreController = TextEditingController();

  /// address
  TextEditingController detailAddressController = TextEditingController();
  TextEditingController pinAddressController = TextEditingController();
  LatLng? latLng;

  bool statusOpenStore = false;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialData();
    });
  }

  @override
  void dispose() {
    administrationController.dispose();

    nameStoreController.dispose();
    emailStoreController.dispose();
    numberStoreController.dispose();
    detailAddressController.dispose();
    descriptionStoreController.dispose();
    super.dispose();
  }

  void initialData() async {
    nameStoreController.text = widget.store.name;
    emailStoreController.text = widget.store.email;
    numberStoreController.text = widget.store.phone;
    descriptionStoreController.text = widget.store.description;
    province = widget.store.province;
    city = widget.store.city;
    district = widget.store.district;
    postalCode = widget.store.postalCode;
    subDistrict = widget.store.subdistrict;
    administrationController.text =
        "$province\n$city\n$district\n$subDistrict\n$postalCode";

    pinAddressController.text = await geocodeParsing(
        LatLng(double.parse(widget.store.lat), double.parse(widget.store.lng)));
    detailAddressController.text = widget.store.address;
    statusOpenStore = widget.store.open == 0 ? false : true;
    setState(() {});
  }

  bool loading = false;
  File? image;

  Future<void> uploadPic(BuildContext context) async {
    ImageSource? imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Source Image"),
              actions: [
                MaterialButton(
                  child: const Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                    child: const Text("Gallery"),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery))
              ],
            ));
    if (imageSource == ImageSource.camera) {
      XFile? xf = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 500,
          maxWidth: 500);
      if (xf != null) {
        setState(() {
          image = File(xf.path);
        });
      }
    }
    if (imageSource == ImageSource.gallery) {
      final resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
            settings: CupertinoSettings(selection: SelectionSetting(max: 1))),
        androidOptions: const AndroidOptions(maxImages: 1),
        // selectedAssets: images,
      );
      for (var imageAsset in resultList) {
        String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
            uri: imageAsset.identifier);
    
        setState(() {
          image = File(filePath!);
        });
      }
    }
  }

  SelectedAdministration? get admModel {
    if (province.isNotEmpty &&
        city.isNotEmpty &&
        district.isNotEmpty &&
        subDistrict.isNotEmpty &&
        postalCode.isNotEmpty) {
      return SelectedAdministration(
          province: AdministrationModel(id: "0", name: province),
          city: AdministrationModel(id: "0", name: city),
          district: AdministrationModel(id: "0", name: district),
          subDistrict: AdministrationModel(id: "0", name: subDistrict),
          postalCode: AdministrationModel(id: "0", name: postalCode));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          getTranslated(
            "TXT_MY_STORE",
            context,
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          Switch.adaptive(
              activeColor: Colors.blue,
              value: statusOpenStore,
              onChanged: (value) {
                statusOpenStore = value;
                setState(() {});
              }),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body:
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
        return KeyboardVisibility(builder: (context, vis, heigt) {
          return Form(
            key: _form,
            child: SizedBox.expand(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: InkWell(
                                onTap: () {
                                  uploadPic(context);
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 3,
                                            spreadRadius: 1,
                                            color: Colors.black.withOpacity(.2),
                                            offset: const Offset(2, 2))
                                      ]),
                                  child: image != null
                                      ? Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                        )
                                      : widget.store.picture != "-"
                                          ? Image.network(
                                              widget.store.picture,
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.store,
                                                size: 40,
                                              ),
                                            ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                              "Profile ${getTranslated("TXT_STORE", context)}"),
                        ),
                        TextFormFieldStoreCstm(
                          controller: nameStoreController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '${getTranslated("NAME", context)} ${getTranslated(
                                "TXT_REQUIRED",
                                context,
                              )}';
                            }
                            return null;
                          },
                          label: getTranslated(
                            "NAME",
                            context,
                          ),
                        ),
                        _divider,
                        TextFormFieldStoreCstm(
                          controller: emailStoreController,
                          label: profileProvider.user?.email ??
                              getTranslated(
                                "EMAIL",
                                context,
                              ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _divider,
                        TextFormFieldStoreCstm(
                          controller: numberStoreController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          label: profileProvider.user?.phone ??
                              getTranslated(
                                "TXT_PHONE_NUMBER",
                                context,
                              ),
                        ),
                        _divider,
                        TextFormFieldStoreCstm(
                          controller: descriptionStoreController,
                          label: getTranslated(
                            "DESCRIPTION",
                            context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("${getTranslated(
                            "TXT_REGION",
                            context,
                          )} ${getTranslated(
                            "TXT_STORE",
                            context,
                          )}"),
                        ),
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
                            final adm = await CustomSelectLocationWidget.go(
                                context,
                                administration: admModel);
                            if (adm != null) {
                              setState(() {
                                province = adm.province.name;
                                city = adm.city.name;
                                district = adm.district.name;
                                subDistrict = adm.subDistrict.name;
                                postalCode = adm.postalCode.name;
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
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("${getTranslated(
                            "ADDRESS",
                            context,
                          )} ${getTranslated(
                            "TXT_STORE",
                            context,
                          )}"),
                        ),
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
                          label: "${getTranslated(
                            "TXT_PIN_POINT",
                            context,
                          )} ${getTranslated(
                            "ADDRESS",
                            context,
                          )}",
                        ),
                        _divider,
                        TextFormFieldStoreCstm(
                          controller: detailAddressController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '${getTranslated(
                                "TXT_DETAIL",
                                context,
                              )} ${getTranslated("ADDRESS", context)} ${getTranslated(
                                "TXT_REQUIRED",
                                context,
                              )}';
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
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loading ? null : _createStore,
                              child: const Text("Simpan"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
                                getTranslated(
                                  "TXT_DONE",
                                  context,
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  Widget get _divider => const Divider(
        height: 0.5,
        thickness: 0.5,
      );

  void _createStore() async {
    FocusScope.of(context).unfocus();
    if (_form.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      try {
        final myPrevStore = context.read<MyStoreProvider>();
        final profile = context.read<ProfileProvider>();
        final email = emailStoreController.text.isEmpty
            ? profile.user?.email ?? '-'
            : emailStoreController.text;
        final phone = numberStoreController.text.isEmpty
            ? profile.user?.phone ?? '-'
            : numberStoreController.text;

        await context.read<MyStoreEditProvider>().updateStore(
              email: email,
              phone: phone,
              name: nameStoreController.text,
              province: province,
              city: city,
              district: district,
              subDistrict: subDistrict,
              postalCode: postalCode,
              detailAddress: detailAddressController.text,
              lat: latLng?.latitude ?? 0,
              long: latLng?.longitude ?? 0,
              file: image,
              statusOpenStore: statusOpenStore,
              oldImage: widget.store.picture,
              description: descriptionStoreController.text,
              storeId: widget.store.storeId,
            );

        myPrevStore.fetchDetailStore();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${getTranslated(
          "TXT_EDIT",
          context,
        )} ${getTranslated("TXT_STORE", context)} ${getTranslated(
          "DONE",
          context,
        )}")));
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // print(e.toString());
      } finally {
        loading = false;
        setState(() {});
      }
    }
  }
}
