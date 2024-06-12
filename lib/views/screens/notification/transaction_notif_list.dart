import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/screens/order_detail/data/order_waiting_payment_model.dart';
import 'package:hp3ki/views/screens/order_detail/data/orders_model.dart';
import 'package:hp3ki/views/screens/order_detail/persentation/pages/order_detail_page.dart';
import 'package:hp3ki/views/screens/shop_payment/persentation/pages/shop_payment_page.dart';

class TransactionNotifList extends StatefulWidget {
  const TransactionNotifList({super.key});

  @override
  State<TransactionNotifList> createState() => _TransactionNotifListState();
}

class _TransactionNotifListState extends State<TransactionNotifList> {
  Dio client = DioManager.shared.getClient();

  String status = 'PAID';
  int page = 1;
  int limit = 10;
  bool loading = true;

  List<OrderData> listPaid = [];
  List<OrderWaitingPayment> listUnpaid = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPaidOrder();
      fetchWaitingPayment();
    });
  }

  void fetchWaitingPayment() async {
    try {
      final res = await client
          .get("${AppConstants.baseUrl}/api/v1/order/waiting-payment");

      listUnpaid = (res.data['data'] as List)
          .map((e) => OrderWaitingPayment.fromJson(e))
          .toList();

      setState(() {});
    } catch (e) {
      //
    }
  }

  void fetchPaidOrder() async {
    try {
      final res = await client.get(
          "${AppConstants.baseUrl}/api/v1/order/all?page=$page&status=$status&search&limit=$limit");

      final orders = OrdersModel.fromJson(res.data['data']);
      page = orders.total == 0 ? page : orders.currentPage;
      listPaid = orders.data;
      setState(() {});
    } catch (e) {
      ///
    } finally {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listUnpaid.isEmpty && listPaid.isEmpty)
            const SizedBox()
          else
            Expanded(
                child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 16,
                ),
                ...List.generate(listUnpaid.length, (index) {
                  final order = listUnpaid[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          ShopPaymentPage.go(paymentId: order.paymentId),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 3,
                            )
                          ],
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.shopify_outlined,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Belanja',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Menunggu pembayaran",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6)),
                                  clipBehavior: Clip.antiAlias,
                                  child: order.productPicture == null
                                      ? const Icon(
                                          Icons.image,
                                        )
                                      : Image.network(
                                          order.productPicture!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${order.productCount} Barang",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        Helper.formatCurrency(
                                          (order.amount + order.paymentFee)
                                              .toDouble(),
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                ...List.generate(listPaid.length, (index) {
                  final order = listPaid[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            OrderDetailPage.go(
                              order.orderId,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 3,
                            )
                          ],
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.shopify_outlined,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Belanja',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  orderStatusFormat(order.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        orderStatusColor(order.status, context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6)),
                                  clipBehavior: Clip.antiAlias,
                                  child: order.productPicture == null
                                      ? const Icon(
                                          Icons.image,
                                        )
                                      : Image.network(
                                          order.productPicture!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${order.productCount} Barang",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        Helper.formatCurrency(
                                          (order.amount + order.shippingAmount)
                                              .toDouble(),
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
              ],
            )),
          // if (listPaid.isEmpty && listUnpaid.isEmpty && !loading)
          //   SizedBox(
          //     width: double.infinity,
          //     height: MediaQuery.of(context).size.height * .7,
          //     child: const Align(
          //       alignment: Alignment.center,
          //       child: Text(
          //         'Belum ada transaksi',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}

String orderStatusFormat(String status) {
  if (status == 'PENDING') {
    return 'Menunggu Konfirmasi';
  }
  if (status == 'CONFIRM') {
    return 'Sedang di proses';
  }
  if (status == 'CANCEL') {
    return 'Pesanan dibatalkan';
  }
  if (status == 'SHIPPING') {
    return 'Dalam Pengiriman';
  }
  if (status == 'FINISHED') {
    return 'Pesanan Selesai';
  }
  if (status == 'DELIVERED') {
    return 'Pesanan Tiba';
  }
  return status;
}

Color orderStatusColor(String status, BuildContext context) {
  if (status == 'PENDING') {
    return Colors.grey;
  }
  if (status == 'CONFIRM') {
    return Colors.grey;
  }
  if (status == 'CANCEL') {
    return Colors.red;
  }
  if (status == 'FINISHED') {
    return Colors.green;
  }
  if (status == 'DELIVERED') {
    return Colors.green;
  }
  return Theme.of(context).colorScheme.primary;
}

class TransactionWaitingPayment extends StatelessWidget {
  const TransactionWaitingPayment({super.key, this.orders = const []});
  final List<OrderWaitingPayment> orders;

  static void show(BuildContext context, List<OrderWaitingPayment> orders) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (_) => TransactionWaitingPayment(
        orders: orders,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(orders.length, (index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: InkWell(
            onTap: () async {
              Navigator.push(
                context,
                ShopPaymentPage.go(paymentId: order.paymentId),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1, 1),
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.circular(
                  6,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopify_outlined,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      const Expanded(
                        child: Text(
                          'Belanja',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "Menunggu pembayaran",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6)),
                        clipBehavior: Clip.antiAlias,
                        child: order.productPicture == null
                            ? const Icon(
                                Icons.image,
                              )
                            : Image.network(
                                order.productPicture!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${order.productCount} Barang",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              Helper.formatCurrency(
                                (order.amount + order.paymentFee).toDouble(),
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
