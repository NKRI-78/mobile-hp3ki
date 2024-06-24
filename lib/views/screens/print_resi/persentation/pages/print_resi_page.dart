// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:hp3ki/views/screens/order_detail/data/order_detail_model.dart';
import 'package:hp3ki/widgets/my_separator.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;

final GlobalKey resiImageKey = GlobalKey();

class PrintResiPage extends StatelessWidget {
  const PrintResiPage({
    Key? key,
    required this.detail,
  }) : super(key: key);

  final OrderDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final RenderRepaintBoundary boundary =
                  resiImageKey.currentContext!.findRenderObject()
                      as RenderRepaintBoundary;
              final ui.Image image = await boundary.toImage();
              ByteData? byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              var pngBytes = byteData!.buffer.asUint8List();
              // var bs64 = base64Encode(pngBytes);

              String dir = (await getTemporaryDirectory()).path;
              File file = File("$dir/${detail.order.buyerName}-hp3ki.png");
              await file.writeAsBytes(
                pngBytes,
              );
              final params = SaveFileDialogParams(sourceFilePath: file.path);
              final finalPath =
                  await FlutterFileDialog.saveFile(params: params);

              debugPrint(finalPath ?? 'Cannot save');
            },
            icon: const Icon(
              Icons.download_outlined,
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: resiImageKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                ),
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        detail.order.shippingTracking ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: MySeparator(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BarcodeWidget(
                        drawText: false,
                        height: 60,
                        data: detail.order.shippingTracking ?? '-',
                        barcode: Barcode.code128(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        top: 8,
                      ),
                      child: MySeparator(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/logo/jne.png',
                            height: 50,
                            width: 80,
                          ),
                          Text(
                            '${detail.order.shippingName} - ${detail.order.shippingCode}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                'Berat',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${detail.orderItems.map((e) => e.orderItemWeight * e.orderItemQuantity).reduce((value, element) => value + element) / 1000} Kg',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        top: 8,
                      ),
                      child: MySeparator(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        bottom: 8,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Pengirim',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      detail.order.storeName,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      detail.order.storePhone,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        bottom: 8,
                        top: 8,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Penerima',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      detail.order.buyerName,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      detail.order.receiverPhone,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      detail.order.shippingAddressDetail,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      detail.order.shippingAddress,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
