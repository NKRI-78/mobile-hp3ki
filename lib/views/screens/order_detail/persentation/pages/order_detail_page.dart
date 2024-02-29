// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/screens/order_detail/domain/order_detail_repository.dart';
import 'package:hp3ki/views/screens/order_detail/persentation/provider/order_detail_provider.dart';
import 'package:hp3ki/views/screens/order_detail/persentation/widgets/review_order_widget.dart';
import 'package:hp3ki/views/screens/print_resi/persentation/pages/print_resi_page.dart';
import 'package:hp3ki/views/screens/product_reviews/persentation/pages/product_reviews_page.dart';
import 'package:hp3ki/views/screens/tracking_order/persentation/pages/tracking_order_page.dart';
import 'package:hp3ki/widgets/my_separator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage(
      {Key? key, required this.orderId, this.isSeller = false})
      : super(key: key);
  final String orderId;
  final bool isSeller;

  static Route go(String orderId, {bool isSeller = false}) => MaterialPageRoute(
        builder: (_) => OrderDetailPage(
          orderId: orderId,
          isSeller: isSeller,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<OrderDetailProvider>(
            create: (_) => OrderDetailProvider(
              repo: OrderDetailRepository(
                client: DioManager.shared.getClient(),
              ),
              orderId: orderId,
            )..getDetail(),
          )
        ],
        child: OrderDetailView(
          isSeller: isSeller,
        ));
  }
}

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, this.isSeller = false});
  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailProvider>(builder: (context, notifier, child) {
      return Scaffold(
        appBar: AppBar(
            // title: Text(
            //   notifier.orderId,
            //   style: const TextStyle(
            //     fontSize: 18,
            //   ),
            // ),
            ),
        body: SizedBox.expand(
          child: notifier.loading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : notifier.detail == null
                  ? const Center(
                      child: Text('No data found'),
                    )
                  : _body(context, notifier),
        ),
      );
    });
  }

  Widget _body(BuildContext context, OrderDetailProvider notifier) {
    final detail = notifier.detail!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No. Invoice',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      detail.order.orderId,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tanggal Pembelian',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      DateFormat().format(detail.order.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
            height: 4,
            thickness: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Produk Detil',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.store_outlined),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(
                              detail.order.storeName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: List.generate(detail.orderItems.length, (index) {
                    final item = detail.orderItems[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 6),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                width: 50,
                                height: 50,
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${item.orderItemQuantity} x ${Helper.formatCurrency(
                                        item.orderItemPrice.toDouble(),
                                      )}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Total Harga',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    Helper.formatCurrency(
                                      (item.orderItemQuantity *
                                              item.orderItemPrice)
                                          .toDouble(),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          if (item.orderItemStatus == 'REVIEWED' && isSeller)
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    ProductReviewsPage.go(item.prdouctId));
                              },
                              child: const Text(
                                "Lihat ulasan",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            )
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
            height: 4,
            thickness: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Info Pengiriman',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kurir',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${detail.order.shippingName} - ${detail.order.shippingCode}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No Resi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                              text: detail.order.shippingTracking ?? '-'),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Nomor resi telah di copy"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            detail.order.shippingTracking ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.copy,
                            size: 16,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    detail.order.buyerName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    detail.order.shippingAddressDetail,
                                    textAlign: TextAlign.end,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    detail.order.shippingAddress,
                                    textAlign: TextAlign.end,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
            height: 4,
            thickness: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Pembayaran',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      detail.order.paymentName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: MySeparator(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Harga',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(detail.order.amount.toDouble()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Ongkos Kirim',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(
                          detail.order.shippingAmount.toDouble()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: MySeparator(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Belanja',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(
                          (detail.order.shippingAmount + detail.order.amount)
                              .toDouble()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (canTrackingOrder(detail.order.status))
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      TrackingOrderPage.go(detail.order.shippingTracking ?? ''),
                    );
                  },
                  child: const Text('Lacak Pesanan'),
                ),
              ),
            ),
          if (detail.order.status == 'DELIVERED' && !isSeller)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: notifier.loadingFinishOrder
                      ? null
                      : () async {
                          try {
                            await context
                                .read<OrderDetailProvider>()
                                .finishOrder();
                          } catch (e) {
                            ///
                          }
                        },
                  child: const Text('Selesaikan Pesanan'),
                ),
              ),
            ),
          if (detail.order.status == 'CONFIRM' && isSeller)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PrintResiPage(detail: detail)));
                  },
                  child: const Text('Print Resi'),
                ),
              ),
            ),
          if (notifier.isCanReview && !isSeller)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: notifier.loadingFinishOrder
                      ? null
                      : () async {
                          try {
                            ReviewOrderAtDetailWidget.show(context);
                          } catch (e) {
                            ///
                          }
                        },
                  child: const Text('Beri Ulasan'),
                ),
              ),
            ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  bool canTrackingOrder(String status) {
    if (status != "PENDING" &&
        status != "WAITING_FOR_PAYMENT" &&
        status != "CONFIRM" &&
        status != "FINISHED" &&
        status != "CANCEL") {
      return true;
    }
    return false;
  }
}
