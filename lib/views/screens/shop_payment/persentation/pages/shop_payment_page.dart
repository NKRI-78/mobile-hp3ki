import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/data/models/ppob_v2/payment_guide.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:intl/intl.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/checkout_response_model.dart';

class ShopPaymentPage extends StatelessWidget {
  const ShopPaymentPage({
    super.key,
    this.payment,
    this.paymentId,
  });

  final Payments? payment;
  final String? paymentId;

  static Route go({Payments? payment, String? paymentId}) {
    return MaterialPageRoute(
      builder: (_) => ShopPaymentPage(
        payment: payment,
        paymentId: paymentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShopPaymentView(
      payment: payment,
      paymentId: paymentId,
    );
  }
}

class ShopPaymentView extends StatefulWidget {
  const ShopPaymentView({
    super.key,
    this.payment,
    this.paymentId,
  });

  final Payments? payment;
  final String? paymentId;

  @override
  State<ShopPaymentView> createState() => _ShopPaymentViewState();
}

class _ShopPaymentViewState extends State<ShopPaymentView> {
  Payments? payment;
  Dio client = DioManager.shared.getClient();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  getData() async {
    if (widget.payment != null) {
      payment = widget.payment;
      setState(() {});
    } else {
      final res = await client.get(
          "${AppConstants.baseUrl}/api/v1/order/${widget.paymentId}/payment");
      payment = Payments.fromJson(res.data['data']);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (payment == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    // final nominal = payment.paymentGuide.split(',').first.split(' ').last;
    // final nominalRm =
    //     nominal.replaceAll('Rp', '').replaceAll('.', '').replaceAll(' ', '');
    // final dateLength = payment!.paymentGuide.split(' ');
    // final date =
    //     '${dateLength[dateLength.length - 2]} ${dateLength[dateLength.length - 1]}';

    DateTime date = payment?.createdAt ?? DateTime.now();
    DateTime date1 = date.add(const Duration(days: 1));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 20.0, bottom: 30.0, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Menunggu Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: payment!.status == 'WAITING_FOR_PAYMENT'
                            ? Colors.red
                            : ColorResources.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      'Batas akhir pembayaran',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat(null, 'id').format(date1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      thickness: 2,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Nomor Virtual Account',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            payment!.paymentNoVa,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: payment!.paymentNoVa),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Nomor VA telah di copy"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Salin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.primary,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.copy,
                                size: 18,
                                color: ColorResources.primary,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Helper.formatCurrency(
                              (payment!.amount + payment!.paymentFee)
                                  .toDouble(),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(
                                  text: (payment!.amount + payment!.paymentFee)
                                      .toString()),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Nominal telah di copy"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Salin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.primary,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.copy,
                                size: 18,
                                color: ColorResources.primary,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorResources.primary,
                        ),
                        color: ColorResources.primary.withOpacity(.3),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorResources.primary,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Text(
                              'Tidak disarankan transfer Virtual Account dari bank selain yang dipilih.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      thickness: 2,
                      height: 1,
                    ),
                    FutureBuilder(
                      future: howToPayment(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PaymentGuideData>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        List<PaymentGuideData> htpd = snapshot.data!;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: htpd.length,
                            itemBuilder: (BuildContext context, int i) {
                              return ExpansionTile(
                                  initiallyExpanded: false,
                                  title: Text(htpd[i].name!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  childrenPadding:
                                      const EdgeInsets.only(bottom: 10.0),
                                  tilePadding: EdgeInsets.zero,
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  expandedAlignment: Alignment.centerLeft,
                                  children: htpd[i]
                                      .steps!
                                      .asMap()
                                      .map(
                                          (int key, StepModel step) => MapEntry(
                                              key,
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    child: Text(
                                                        '${step.step}. ',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      step.description!,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              )))
                                      .values
                                      .toList());
                            });
                      },
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future<List<PaymentGuideData>> howToPayment() async {
    try {
      Dio dio = Dio();
      Response res = await dio.get(
        payment!.paymentGuideUrl,
      );
      Map<String, dynamic> data = res.data;
      PaymentGuideModel howToPayModel = PaymentGuideModel.fromJson(data);
      return howToPayModel.body!;
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }
}
