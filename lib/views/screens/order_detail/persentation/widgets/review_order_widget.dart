// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hp3ki/utils/dio.dart';

import 'package:hp3ki/views/screens/order_detail/persentation/provider/order_detail_provider.dart';
import 'package:hp3ki/widgets/my_separator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';

class ReviewOrderAtDetailWidget extends StatefulWidget {
  const ReviewOrderAtDetailWidget({super.key});

  static show(BuildContext context) async {
    showModalBottomSheet(
        showDragHandle: true,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (_) => MultiProvider(providers: [
              ChangeNotifierProvider.value(
                value: context.read<OrderDetailProvider>(),
              ),
            ], child: const ReviewOrderAtDetailWidget()));
  }

  @override
  State<ReviewOrderAtDetailWidget> createState() =>
      _ReviewOrderAtDetailWidgetState();
}

class _ReviewOrderAtDetailWidgetState extends State<ReviewOrderAtDetailWidget> {
  Map<String, OrderReviewHelper> review = {};
  bool loading = false;

  Dio client = DioManager.shared.getClient();

  void _submit() async {
    try {
      final state = context.read<OrderDetailProvider>();
      if (review.keys.length == state.detail?.orderItems.length &&
          review.values.where((element) => element.rating == 0).isEmpty) {
        setState(() {
          loading = true;
        });
        await state.reviewOrder(review);
        await state.getDetail();
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ada produk yang tidak di kasih rating')));
      }
    } catch (e) {
      // print(e.toString());

      ///
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailProvider>(
      builder: (context, notifier, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...List.generate(notifier.detail?.orderItems.length ?? 0, (index) {
              final item = notifier.detail!.orderItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: 80,
                          height: 80,
                          child: item.productPicture == null
                              ? const Icon(Icons.image)
                              : Image.network(
                                  item.productPicture!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              RatingBar.builder(
                                initialRating: 0,
                                itemSize: 30,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    review[item.prdouctId] =
                                        review[item.prdouctId]?.copyWith(
                                                orderItemId: item.orderItemNote,
                                                rating: rating.toInt()) ??
                                            OrderReviewHelper(
                                                rating: rating.toInt());
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        setState(() {
                          review[item.prdouctId] = review[item.prdouctId]
                                  ?.copyWith(caption: value) ??
                              OrderReviewHelper(caption: value);
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Masukkan ulasan',
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      minLines: 4,
                      maxLines: 4,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: review[item.prdouctId] == null ||
                                  (review[item.prdouctId]?.files.isEmpty ??
                                      false)
                              ? [
                                  _imageEmpty(item.prdouctId),
                                ]
                              : [
                                  ...List.generate(
                                      review[item.prdouctId]!.files.length,
                                      (index) => _imageFromFile(
                                          review[item.prdouctId]!.files[index],
                                          item.prdouctId,
                                          index)),
                                  if (review[item.prdouctId]!.files.length < 5)
                                    _imageEmpty(item.prdouctId),
                                ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const MySeparator(
                      color: Colors.grey,
                    )
                  ],
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _submit,
                child: const Text('Submit Review'),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _imageFromFile(File file, String productId, int index) => Stack(
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
            top: -8,
            child: InkWell(
              onTap: () {
                setState(() {
                  review[productId] = review[productId]!..files.removeAt(index);
                });
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

  Widget _imageEmpty(String productId) => InkWell(
        onTap: () async {
          ImageSource? imageSource = await showDialog<ImageSource>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Source Image"),
                    actions: [
                      MaterialButton(
                        child: const Text("Camera"),
                        onPressed: () =>
                            Navigator.pop(context, ImageSource.camera),
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
                review[productId] = review[productId]?.copyWith(
                        files: [...review[productId]!.files, File(xf.path)]) ??
                    OrderReviewHelper(files: [File(xf.path)]);
              });
            }
          }
          if (imageSource == ImageSource.gallery) {
            final resultList = await MultiImagePicker.pickImages(
              iosOptions: IOSOptions(
                  settings: CupertinoSettings(
                      selection: SelectionSetting(
                          max: 5 - (review[productId]?.files.length ?? 0)))),
              androidOptions: AndroidOptions(
                  maxImages: 5 - (review[productId]?.files.length ?? 0)),
              // selectedAssets: images,
            );
            List<File> pathsGalery = [];
            for (var imageAsset in resultList) {
              String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(
                  uri: imageAsset.identifier);
              File compressedFile = await FlutterNativeImage.compressImage(
                  filePath!,
                  quality: 50,
                  percentage: 50);
              pathsGalery.add(File(compressedFile.path));
            }

            setState(() {
              review[productId] = review[productId]?.copyWith(
                      files: [...review[productId]!.files, ...pathsGalery]) ??
                  OrderReviewHelper(files: pathsGalery);
            });
          }
        },
        child: Container(
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
        ),
      );
}

class OrderReviewHelper {
  String caption;
  int rating;
  List<File> files;
  String orderItemId;

  OrderReviewHelper({
    this.caption = '',
    this.orderItemId = '',
    this.rating = 0,
    this.files = const [],
  });

  OrderReviewHelper copyWith({
    String? caption,
    int? rating,
    List<File>? files,
    String? orderItemId,
  }) {
    return OrderReviewHelper(
      caption: caption ?? this.caption,
      rating: rating ?? this.rating,
      files: files ?? this.files,
      orderItemId: orderItemId ?? this.orderItemId,
    );
  }
}
