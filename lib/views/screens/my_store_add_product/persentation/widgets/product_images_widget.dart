import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/my_store_add_product/persentation/providers/my_store_add_product_proivder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';

class ProductImagesWidget extends StatefulWidget {
  const ProductImagesWidget({super.key});

  @override
  State<ProductImagesWidget> createState() => _ProductImagesWidgetState();
}

class _ProductImagesWidgetState extends State<ProductImagesWidget> {
  Future<void> uploadPic(BuildContext context) async {
    final provider = context.read<MyStoreAddProductProvider>();
    final imageNow = provider.images.length;

    if (imageNow == 5) {
      GeneralModal.error(context,
          msg:
              '${getTranslated('TXT_IMAGE', context)} ${getTranslated('TXT_PRODUCT', context)} maks 5',
          onOk: () {
        Navigator.pop(context);
      });
      return;
    }
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
        provider.setImages([File(xf.path)]);
      }
    }
    if (imageSource == ImageSource.gallery) {
      final resultList = await MultiImagePicker.pickImages(
        iosOptions: IOSOptions(
            settings: CupertinoSettings(
                selection: SelectionSetting(max: 5 - imageNow))),
        androidOptions: AndroidOptions(maxImages: 5 - imageNow),
        // selectedAssets: images,
      );

      for (var imageAsset in resultList) {
        String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
        provider.setImages([File(filePath!)]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          text: "${getTranslated(
                            "TXT_IMAGE",
                            context,
                          )} ${getTranslated(
                            "TXT_PRODUCT",
                            context,
                          )}",
                        ),
                        const TextSpan(
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            text: " *")
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      uploadPic(context);
                    },
                    child: Text(
                      '${getTranslated(
                        "TXT_ADD",
                        context,
                      )} ${getTranslated(
                        "TXT_IMAGE",
                        context,
                      )}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Consumer<MyStoreAddProductProvider>(
            builder: (context, notifier, child) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notifier.images.isEmpty
                      ? [_imageEmpty]
                      : List.generate(
                          notifier.images.length,
                          (index) {
                            final img = notifier.images[index];
                            if (img is File) {
                              return _imageFromFile(img, index);
                            }
                            return _imageFromUrl(img as String, index);
                          },
                        ),
                ),
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _imageFromFile(File file, int index) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 65,
            margin: const EdgeInsets.only(
              right: 6,
            ),
            clipBehavior: Clip.antiAlias,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                6,
              ),
            ),
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 2,
            top: -4,
            child: InkWell(
              onTap: () {
                context
                    .read<MyStoreAddProductProvider>()
                    .removeImageIndex(index);
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          )
        ],
      );

  Widget _imageFromUrl(String src, int index) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 65,
            margin: const EdgeInsets.only(
              right: 6,
            ),
            clipBehavior: Clip.antiAlias,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                6,
              ),
            ),
            child: Image.network(
              src,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 2,
            top: -4,
            child: InkWell(
              onTap: () {
                context
                    .read<MyStoreAddProductProvider>()
                    .removeImageIndex(index);
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          )
        ],
      );

  Widget get _imageEmpty => Container(
        height: 65,
        margin: const EdgeInsets.only(
          right: 6,
        ),
        clipBehavior: Clip.antiAlias,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(
            6,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 40,
          ),
        ),
      );
}
