import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/providers/ecommerce/ecommerce.dart';

import 'package:provider/provider.dart';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/custom_themes.dart';

import 'package:hp3ki/views/basewidgets/button/custom.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> kindStuff = [
    "Berbahaya",
    "Mudah Terbakar",
    "Cair",
    "Mudah Pecah"
  ];

  List<dynamic> kindStuffSelected = [];

  String typeConditionName = "NEW";
  int typeCondition = 0;
  String? idCategoryparent;

  ImageSource? imageSource;

  List<Asset> images = [];
  List<File> files = [];
  List<File> before = [];

  late TextEditingController nameC;
  late TextEditingController priceC;
  late TextEditingController stockC;
  late TextEditingController weightC;
  late TextEditingController minOrderC;

  void pickImage() async {
    var imageSource = await showDialog<ImageSource>(context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Pilih sumber gambar",
          style: robotoRegular,
        ),
        actions: [
          MaterialButton(
            child: const Text("Kamera",
              style: robotoRegular,
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: const Text( "Galeri",
              style: robotoRegular,
            ),
            onPressed: uploadPic,
          )
        ],
      )
    );
    if (imageSource != null) {
      XFile? file = await ImagePicker().pickImage(source: imageSource, maxHeight: 720);
      File f = File(file!.path);
      setState(() {
        before.add(f);
        files = before.toSet().toList();
      });
    }
  }
  
  void uploadPic() async {
    List<Asset> resultList = [];
    if(files.isEmpty) {
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: [],
        androidOptions: const AndroidOptions(
          maxImages: 5,
          hasCameraInPickerPage: false
        )
      );
    } else if(files.length == 4) { 
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: [],
        androidOptions: const AndroidOptions(
          maxImages: 1,
          hasCameraInPickerPage: false
        )
      );
    } else if(files.length == 3) { 
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: [],
        androidOptions: const AndroidOptions(
          maxImages: 2,
          hasCameraInPickerPage: false
        )
      );
    } else if(files.length == 2) { 
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: [],
        androidOptions: const AndroidOptions(
          maxImages: 3,
          hasCameraInPickerPage: false
        )
      );
    } else { 
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: [],
        androidOptions: const AndroidOptions(
          maxImages: 4,
          hasCameraInPickerPage: false
        )
      );
    } 
    Navigator.of(context, rootNavigator: true).pop();
    for (Asset imageAsset in resultList) {
      final filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
      File tempFile = File(filePath!);
      setState(() {
        images = resultList;
        before.add(tempFile);
        files = before.toSet().toList();
      });
    }
  }

  @override 
  void initState() {
    super.initState();

    nameC = TextEditingController();
    priceC = TextEditingController();
    stockC = TextEditingController();
    weightC = TextEditingController();
    minOrderC = TextEditingController();
  }

  @override 
  void dispose() {
    nameC.dispose();
    priceC.dispose();
    stockC.dispose();
    weightC.dispose();
    minOrderC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
      leading: CupertinoNavigationBarBackButton(
        color: ColorResources.white,
        onPressed: () {
          
        },
      ),
      centerTitle: true,
      elevation: 0,
      title: Text( "Jual Barang",
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          fontWeight: FontWeight.w600,
          color: ColorResources.white
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            inputFieldCategory("Kategori Barang *", "Kategori Barang"),
            
            const SizedBox(height: 15.0),

            inputFieldName(nameC),
            
            const SizedBox(height: 15.0),
            
            inputFieldPrice(context, priceC),
            
            const SizedBox(
              height: 15.0,
            ),

            Row(
              children: [
                SizedBox(
                  width: 120.0,
                  child: inputFieldStock(context, stockC)
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inputFieldWeight(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 15.0,
            ),
            
            Text("Kondisi *",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              )
            ),
            
            const SizedBox(
              height: 10.0,
            ),
            
            Wrap(
              children: [ 
                SizedBox(
                  height: 30.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ['Baru', 'Bekas'].length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        margin: EdgeInsets.only(left: i == 0 ? 0.0 : 10.0),
                        child: ChoiceChip(
                          label: Text(['Baru', 'Bekas'][i],
                            style: robotoRegular.copyWith(
                              color: typeCondition == i 
                              ? ColorResources.white
                              : ColorResources.primaryOrange
                            ),
                          ),
                          selectedColor: ColorResources.primaryOrange,
                          selected: typeCondition == i,
                          onSelected: (bool selected) {
                            setState(() {
                              typeCondition = (selected ? i : null)!;
                              typeConditionName = ['Baru', 'Bekas'][i] == "Baru" ? "NEW" : "USED";
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]
            ),

            const SizedBox(
              height: 10.0,
            ),
            
            ChipsChoice.multiple(
              wrapped: true,
              padding: EdgeInsets.zero,
              errorBuilder: (context) => Container(),
              placeholder: "",
              value: kindStuffSelected,
              onChanged: (val) => setState(() => kindStuffSelected = val),
              choiceItems: C2Choice.listFrom<int, String>(
                source: kindStuff,
                value: (i, v) => i,
                label: (i, v) => v,
              ), 
            ),

            const SizedBox(
              height: 15.0,
            ),
            
            inputFieldDescription(),
            
            const SizedBox(
              height: 15.0,
            ),
            
            Text("Gambar Barang *",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              )
            ),
            
            const SizedBox(
              height: 10.0,
            ),
            
            Container(
              height: 100.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5)
                ),
                borderRadius: BorderRadius.circular(10.0)
              ),
                child: files.isEmpty
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              color: Colors.grey.withOpacity(0.5)
                            ),
                            child: Center(
                              child: files.isEmpty
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[600],
                                  size: 35,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    image: FileImage(files.first),
                                    placeholder: const AssetImage("assets/images/logo/starlet.png")
                                  ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Upload Gambar Barang",
                              style: robotoRegular.copyWith(
                                fontSize: 12.0,
                              )
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text("Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                              style: robotoRegular.copyWith(
                                fontSize: 12.0,
                                color: Colors.grey[600]
                              )
                            ),
                          ],
                        ))
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length + 1,
                      itemBuilder: (context, index) {
                        if (index < files.length) {
                          return Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey[400]!
                              ),
                              color: Colors.grey[350]
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  image: FileImage(files[index]),
                                  placeholder: const AssetImage("assets/images/logo/starlet.png")
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (files.length < 5) {
                                pickImage();
                              } else if (files.length >= 5) {
                                setState(() {
                                  files.clear();
                                  before.clear();
                                  images.clear();
                                });
                              }
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey[400]!
                              ),
                              color: files.length < 5 ? Colors.grey[350] : Colors.red),
                              child: Center(
                                child: Icon(
                                  files.length < 5 ? Icons.camera_alt : Icons.delete,
                                  color: files.length < 5 ? Colors.grey[600] : ColorResources.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  CustomButton(
                    isBorder: false,
                    isBoxShadow: false,
                    isBorderRadius: true,
                    btnColor: ColorResources.primary,
                    btnTextColor: ColorResources.white,
                    onTap: () {}, 
                    btnTxt: "Jual Barang"
                  )
                ],
              )
            ),
          )
        ],
      )
    );
  }

  Widget inputFieldName(TextEditingController controller) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Nama Barang *",
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
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
            controller: controller,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: "Masukan Nama Barang",
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0, 
                horizontal: 15.0
              ),
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

  Widget inputFieldDescription() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Deskripsi Barang", 
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
                return Consumer(
                  builder: (BuildContext context, EcommerceProvider notifier,  Widget? child) {
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
                                  padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, 
                                    top: 16.0, bottom: 8.0
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          NS.pop();
                                        },
                                        child: const Icon(
                                          Icons.close
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16.0),
                                        child: Text("Masukan Deskripsi",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          )
                                        )
                                      ),
                                      // storeProvider.descAddSellerStore != null
                                      // ? GestureDetector(
                                      //     onTap: () {
                                      //       NS.pop();
                                      //     },
                                      //     child: const Icon(
                                      //       Icons.done,
                                      //       color: ColorResources.btnPrimary
                                      //     )
                                      //   )
                                      // : const SizedBox(),
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
                                    autofocus: true,
                                    onChanged: (val) {
                                
                                    },
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      hintText: "Masukan Deskripsi Barang Anda",
                                      hintStyle: robotoRegular.copyWith(
                                        color: ColorResources.black
                                      ),
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
              }
            );
          },
          child: Consumer<EcommerceProvider>(
            builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
              return Container(
                height: 120.0,
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                ),
                child: Text("Masukan Deskripsi Barang Anda",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault, 
                    color: ColorResources.black 
                  )
                )
              );
            },
          )
        ),
      ],
    );             
  }

  Widget inputFieldStock(BuildContext context, TextEditingController controller) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Stok *",
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
            controller: controller,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.number,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "0",
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

  Widget inputFieldPrice(BuildContext context, TextEditingController controller) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Harga *",
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
            controller: controller,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.number,
            style: robotoRegular,
            decoration: InputDecoration(
            fillColor: ColorResources.white,
            prefixIcon: SizedBox(
              width: 50,
              child: Center(
                child: Text("Rp",
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                )),
              ),
              hintText: "0",
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

  
  Widget inputFieldCategory(String title, String hintText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Consumer(
                    builder: (BuildContext context, EcommerceProvider notifier, Widget? child) {
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
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
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
                                          child: Text("Kategori Barang",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            )
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 3.0,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (BuildContext context, int i) => const Divider(
                                        color: ColorResources.dimGrey,
                                        thickness: 0.1,
                                      ),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: ["text1", "text2", "text3"].length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Container(
                                          margin: const EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(["text1", "text2", "text3"][i],
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  fontWeight: FontWeight.w600
                                                )
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  NS.pop();
                                                },
                                                child: const Text("Pilih",
                                                  style: robotoRegular,
                                                ),
                                              )                                              
                                            ],
                                          ),
                                        );                                                                      
                                      },
                                    )  
                                  )                                
                                ],
                              ),
                            ],
                          ),
                        )
                      );
                    }, 
                  );
                }
              );
            },
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: "Kategori Barang",
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
          )
      
        )
        
      ]
    );
  }

  Widget inputFieldWeight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          alignment: Alignment.centerLeft,
          child: Text("Berat *",
            style: robotoRegular.copyWith(
              fontSize: 13.0,
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
            controller: weightC,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.number,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "0",
              isDense: true,
              suffixIcon: SizedBox(
                width: 80.0,
                child: Center(
                  child: Text("Gram",
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
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
  
}