import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hp3ki/maps/src/utils/uuid.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'package:hp3ki/maps/src/place_picker.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/providers/ecommerce/ecommerce.dart';
import 'package:hp3ki/providers/profile/profile.dart';

class CreateStoreOrUpdateScreen extends StatefulWidget {
  const CreateStoreOrUpdateScreen({
    super.key
  });

  @override
  State<CreateStoreOrUpdateScreen> createState() => CreateStoreOrUpdateScreenState();
}

class CreateStoreOrUpdateScreenState extends State<CreateStoreOrUpdateScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String storeLogo = "";  

  String provinceName = "";
  String cityName = "";
  String districtName = "";
  String subdistrictName = "";

  String location = "";

  String lat = "";
  String lng = "";

  bool isOpen = false;
  bool isLoading = false;

  File? file;

  late EcommerceProvider ecommerceProvider;
  late ProfileProvider profileProvider;

  late TextEditingController nameStoreC;
  late TextEditingController descStoreC;
  late TextEditingController provinceC;
  late TextEditingController cityC;
  late TextEditingController districtC;
  late TextEditingController subdistrictC;
  late TextEditingController postCodeC;
  late TextEditingController addressC;
  late TextEditingController emailC;
  late TextEditingController phoneC;

  Future<void> getData() async {
    if(!mounted) return;
      ecommerceProvider.getProvince(search: "");
  }
  
  void pickImage() async {

    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih sumber gambar",
          style: robotoRegular,
        ),
        actions: [
          MaterialButton(
            child: const Text(
              "Kamera",
              style: robotoRegular,
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: const Text(
              "Galeri",
              style: robotoRegular,
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          )
        ],
      )
    );

    if (imageSource != null) {
      XFile? xfile = await ImagePicker().pickImage(source: imageSource, maxHeight: 720);
      File f = File(xfile!.path);
      setState(() {
        storeLogo = "";
        file = f;
      });      
    }

  }

  Future<void> submit() async {

    String id = Uuid().generateV4();

    if(nameStoreC.text.isEmpty) {
      ShowSnackbar.snackbar("Nama Toko wajib diisi", "", ColorResources.error);
      return;
    }

    if(descStoreC.text.isEmpty) {
      ShowSnackbar.snackbar("Deskripsi Toko wajib diisi", "", ColorResources.error);
      return;
    }

    if(provinceC.text.isEmpty) {
      ShowSnackbar.snackbar("Provinsi wajib diisi", "", ColorResources.error);
      return;
    }

    if(cityC.text.isEmpty) {
      ShowSnackbar.snackbar("Kota wajib diisi", "", ColorResources.error);
      return;
    }

    if(districtC.text.isEmpty) {
      ShowSnackbar.snackbar("Kecamatan wajib diisi", "", ColorResources.error);
      return;
    }

    if(subdistrictC.text.isEmpty) {
      ShowSnackbar.snackbar("Kelurahan wajib diisi", "", ColorResources.error);
      return;
    }

    if(addressC.text.isEmpty) {
      ShowSnackbar.snackbar("Alamat wajib diisi", "", ColorResources.error);
      return;
    }

    await ecommerceProvider.createStore(
      id: id, 
      logo: file!, 
      name: nameStoreC.text, 
      caption: descStoreC.text, 
      province: provinceC.text, 
      city: cityC.text, 
      district: districtC.text, 
      subdistrict: subdistrictC.text, 
      address: addressC.text, 
      email: emailC.text, 
      phone: phoneC.text, 
      lat: lat, 
      lng: lng, 
      isOpen: isOpen,
      postCode: postCodeC.text
    );
  }

  @override
  void initState() {
    super.initState();
      
    ecommerceProvider = context.read<EcommerceProvider>();
    profileProvider = context.read<ProfileProvider>();

    Future.microtask(() => getData());
    
    nameStoreC = TextEditingController();
    descStoreC = TextEditingController();
    provinceC = TextEditingController();
    cityC = TextEditingController();
    districtC = TextEditingController();
    subdistrictC = TextEditingController();
    postCodeC = TextEditingController();
    addressC = TextEditingController();
    emailC = TextEditingController(text: profileProvider.user?.email ?? "");
    phoneC = TextEditingController(text: profileProvider.user?.phone ?? "");
      
    descStoreC = TextEditingController();
    descStoreC.addListener(() {
      setState(() {});
    });

    setState(() => isLoading = true);

    Future.delayed(Duration.zero, () async {

      await ecommerceProvider.getStore();

      setState(() => isLoading = false);

      final store =  ecommerceProvider.store.data;

      setState(() {
        storeLogo = store?.logo ?? "";
        nameStoreC = TextEditingController(text: isLoading ? "" : store?.name ?? "");
        descStoreC = TextEditingController(text: isLoading ? "" : store?.description ?? "");
        provinceC = TextEditingController(text: isLoading ? "" : store?.province ?? "");
        cityC = TextEditingController(text: isLoading ? "" : store?.city ?? "");
        districtC = TextEditingController(text: isLoading ? "" : store?.district ?? "");
        subdistrictC = TextEditingController(text: isLoading ? "" : store?.subdistrict ?? "");
        postCodeC = TextEditingController(text: isLoading ? "" : store?.postalCode ?? "");
        addressC = TextEditingController(text: isLoading ? "" : store?.address ?? "");
        emailC = TextEditingController(text: isLoading ? "" : store?.email ?? "");
        phoneC = TextEditingController(text: isLoading ? "" : store?.phone ?? "");
      });

    });
    
  }

  @override
  void dispose() {
    nameStoreC.dispose();
    descStoreC.dispose();
    provinceC.dispose();
    cityC.dispose();
    districtC.dispose();
    subdistrictC.dispose();
    postCodeC.dispose();
    addressC.dispose();
    emailC.dispose();
    phoneC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorResources.primary,
        centerTitle: true,
        elevation: 0.0,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop();
          },
        ),
        title: Text("Buka Toko",
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Stack(
                    clipBehavior: Clip.none,
                    children: [

                      InkWell(
                        onTap: pickImage,
                        child: storeLogo.isNotEmpty 
                        ? CachedNetworkImage(
                            imageUrl: storeLogo,
                            imageBuilder: (BuildContext context,  ImageProvider<Object> imageProvider) {
                              return CircleAvatar(
                                backgroundColor: ColorResources.white,
                                backgroundImage: imageProvider,
                                maxRadius: 50.0,
                              );
                            },
                            placeholder: (BuildContext context, String url) {
                              return const CircleAvatar(
                                backgroundColor: ColorResources.white,
                                maxRadius: 50.0,
                                child: Icon(
                                  Icons.store,
                                  size: 80.0,
                                  color: ColorResources.primary,
                                ),
                              ); 
                            },
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return const CircleAvatar(
                                backgroundColor: ColorResources.white,
                                maxRadius: 50.0,
                                child: Icon(
                                  Icons.store,
                                  size: 80.0,
                                  color: ColorResources.primary,
                                ),
                              ); 
                            },
                          )
                        : file == null 
                        ? const CircleAvatar(
                            backgroundColor: ColorResources.white,
                            maxRadius: 50.0,
                            child: Icon(
                              Icons.store,
                              size: 80.0,
                              color: ColorResources.primary,
                            ),
                          )  
                        : CircleAvatar(
                            backgroundColor: ColorResources.white,
                            maxRadius: 50.0,
                            backgroundImage: FileImage(file!)
                          )
                        ),

                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: const Icon(Icons.edit)
                        )
                      ),

                      
                    ]
                  ),
                  
                  inputFieldStoreName("Nama Toko", nameStoreC, "Nama Toko"),
                  
                  const SizedBox(
                    height: 15.0,
                  ),
                  
                  inputFieldProvince("Provinsi", "Provinsi"),
                  
                  const SizedBox(
                    height: 15.0,
                  ),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      inputFieldCity("Kota", "Kota"),    
                      
                      const SizedBox(width: 15.0), 

                      inputFieldPostCode("Kode Pos", postCodeC, "Kode Pos"),
                    ],
                  ),
                  
                  const SizedBox(height: 15.0),
                  
                  inputFieldDistrict(),
                  
                  const SizedBox(height: 15.0),
                  
                  inputFieldSubdistrict("Kelurahan", "Kelurahan"),
                  
                  const SizedBox(height: 15.0),
                  
                  inputFieldEmailAddress("E-mail Address", emailC, "E-mail Address"),
                  
                  const SizedBox(height: 15.0),
                  
                  inputFieldPhoneNumber("Nomor HP", phoneC, "Nomor HP"),
                  
                  const SizedBox(
                    height: 15.0,
                  ),

                  inputFieldAddress(),
                  
                  const SizedBox(
                    height: 15.0,
                  ),

                  inputFieldDescriptionStore(descStoreC),    
                  
                  const SizedBox(
                    height: 15.0,
                  ),

                  toggleIsOpen(),

                  const SizedBox(
                    height: 25.0,
                  ),

                  SizedBox(
                    height: 55.0,
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: ColorResources.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                      ),
                      child: Center(
                        child: context.watch<EcommerceProvider>().createStoreStatus == CreateStoreStatus.loading 
                        ? const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator()
                          ) 
                        : Text("Submit",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.white
                          )
                        ),
                      ),
                      onPressed: submit
                    ),
                  )

                ],
              )
            )
          )

        ]
      ),
    );
  }

  Widget inputFieldStoreName(String title, TextEditingController controller, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Nama Toko",
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: TextFormField(
            readOnly: false,
            cursorColor: ColorResources.black,
            controller: controller,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            maxLength: 30,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              filled: true,
              fillColor: ColorResources.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget inputFieldProvince(String title, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                      )
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          NS.pop();
                                        },
                                        child: const Icon(
                                          Icons.close
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Text("Pilih Provinsi Anda",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          )
                                        )
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 3,
                            ),
                            Expanded(
                              flex: 40,
                              child: Consumer<EcommerceProvider>(
                                builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: notifier.provinces.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return ListTile(
                                        title: Text(notifier.provinces[i].provinceName),
                                        onTap: () async {
                                          setState(() {
                                            provinceName = notifier.provinces[i].provinceName;
                                            provinceC.text = provinceName;
                                          });
                                          NS.pop();
                                          await ecommerceProvider.getCity(provinceName: provinceName, search: "");
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        thickness: 1,
                                      );
                                    },
                                  );
                                },
                              )  
                            ),
                          ]
                        ),
                      ])
                    )
                  );            
                }
              );
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: provinceC,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    );          
  }

  Widget inputFieldCity(String title, String hintText) {
    return Expanded(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.96,
                    color: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)
                        )
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 16.0, 
                                  right: 16.0, 
                                  top: 16.0,
                                  bottom: 8.0
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          onTap: () => NS.pop(),
                                          child: const Icon(
                                            Icons.close
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 16.0),
                                          child: Text("Pilih Kota Anda",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            )
                                          )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 3.0,
                              ),
                              Expanded(
                                flex: 40,
                                child: Consumer<EcommerceProvider>(
                                  builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: notifier.city.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return ListTile(
                                          title: Text(notifier.city[i].cityName),
                                          onTap: () async {
                                            setState(() {
                                              cityName = notifier.city[i].cityName;
                                              cityC.text = cityName;
                                            });
                                            NS.pop();
                                            await ecommerceProvider.getDistrict(cityName: cityName, search: "");
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                        );
                                      },
                                    );
                                  },
                                )
                              )
                            ]
                          )
                        ]
                      )
                    )
                  );
                },
              );
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: cityC,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget inputFieldPhoneNumber(String title, TextEditingController controller, String hintText) {
    return Column(
      children: [
      Container(
        alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),   
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: controller,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: Theme.of(context).hintColor
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget inputFieldAddress() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Alamat",
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        )
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text("(Berdasarkan pinpoint)",
                        style: robotoRegular.copyWith(
                          fontSize: 12.0,
                          color: Colors.grey[600]
                        )
                      ),
                    ],
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () async {
                      NS.push(context, PlacePicker(
                        apiKey: AppConstants.apiKeyGmaps,
                        useCurrentLocation: true,
                        onPlacePicked: (result) async {
                          setState(() {
                            location = result.formattedAddress!.isNotEmpty
                            ? result.formattedAddress.toString()
                            : '-';
                            addressC.text = result.formattedAddress.toString();
                            lat = result.geometry?.location.lat.toString() ?? '-';
                            lng = result.geometry?.location.lng.toString() ?? '-';
                          });
                          NS.pop();
                        },
                        autocompleteLanguage: "id",
                      ));
                    },
                    child: Text("Ubah Lokasi",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.primary
                      )
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 3.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
              child: Text(location.isEmpty 
              ? "Location no Selected" 
              : location,
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeDefault
                )
              ),
            ),
          ]
        )
      )
    );
  }

  Widget inputFieldDistrict() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text('Kecamatan',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () { 
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: ColorResources.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                      )
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          NS.pop();
                                        },
                                        child: const Icon(
                                          Icons.close
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Text("Pilih Kecamatan Anda",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          )
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 3,
                            ),
                            Expanded(
                              flex: 40,
                              child: Consumer<EcommerceProvider>(
                                builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: notifier.district.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return ListTile(
                                        title: Text(notifier.district[i].districtName),
                                        onTap: () async {
                                          setState(() {
                                            districtName = notifier.district[i].districtName;
                                            districtC.text = districtName;
                                          });
                                          NS.pop();
                                          await ecommerceProvider.getSubdistrict(districtName: districtName, search: "");
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        thickness: 1,
                                      );
                                    },
                                  );
                                },
                              )                             
                            ),
                          ],
                        ),
                      ])
                    )
                  );
                },
              );
            },
            readOnly: true,
            controller: districtC,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    );       
  }

  Widget inputFieldSubdistrict(String title, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),   
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: ColorResources.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)
                      )
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          NS.pop();
                                        },
                                        child: const Icon(
                                          Icons.close
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Text("Pilih Kecamatan Anda",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          )
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 3,
                            ),
                            Expanded(
                              flex: 40,
                              child: Consumer<EcommerceProvider>(
                                builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: notifier.subdistrict.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return ListTile(
                                        title: Text(notifier.subdistrict[i].subdistrictName),
                                        onTap: () async {
                                          setState(() {
                                            subdistrictName = notifier.subdistrict[i].subdistrictName;
                                            subdistrictC.text = subdistrictName;
                                            postCodeC.text = notifier.subdistrict[i].zipCode.toString();
                                          });
                                          NS.pop();
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        thickness: 1,
                                      );
                                    },
                                  );
                                },
                              )                             
                            ),
                          ],
                        ),
                      ])
                    )
                  );
                },
              );
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: subdistrictC,
            style: robotoRegular,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget inputFieldPostCode(String title, TextEditingController controller, String hintText) {
    return SizedBox(
    width: 150.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            readOnly: true,
            controller: controller,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputFieldDetailAddress(String title, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            cursorColor: ColorResources.black,
            controller: addressC,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: Theme.of(context).hintColor
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ]
    );
  }

  Widget inputFieldEmailAddress(String title, TextEditingController controller, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),   
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            readOnly: true , 
            cursorColor: ColorResources.black,
            controller: controller,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: Theme.of(context).hintColor
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.5
                ),
              ),
            ),
          ),
        )
      ],
    ); 
  }

  Widget toggleIsOpen() {
    return SwitchListTile(
      title: Text('Buka toko',
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: ColorResources.black
        ),
      ),
      value: isOpen,
      onChanged: (bool val) {
        setState(() {
          isOpen = val;
        });
      },
    );
  }

  Widget inputFieldDescriptionStore(TextEditingController controller) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Deskripsi Toko", 
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return  Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  color: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)
                        )
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        NS.pop();
                                      },
                                      child: const Icon(
                                        Icons.close
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      child: Text("Masukan Deskripsi",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        )
                                      )
                                    ),
                                    controller.text.isNotEmpty
                                    ? InkWell(
                                      onTap: () {
                                        NS.pop();
                                      },
                                      child: const Icon(
                                        Icons.done,
                                        color: ColorResources.black
                                      )
                                    )
                                    : Container(),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 3,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: TextFormField(
                                  controller: controller,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    fillColor: ColorResources.white,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  style: robotoRegular
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  );
                }, 
              );
            },
            child: Container(
              height: 120.0,
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Text(controller.text == '' 
              ? "" 
              : controller.text,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault, 
                color: controller.text.isNotEmpty 
                ? ColorResources.black 
                : Theme.of(context).hintColor
              )
            )
          ),
        ),
      ],
    );             
  }

}