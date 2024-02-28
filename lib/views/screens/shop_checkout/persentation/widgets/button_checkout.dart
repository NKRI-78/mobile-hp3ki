import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:hp3ki/views/screens/shop_payment/persentation/pages/shop_payment_page.dart';
import 'package:provider/provider.dart';

class ButtonCheckout extends StatelessWidget {
  const ButtonCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCheckoutProvider>(builder: (context, notifier, child) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: notifier.loading
                    ? null
                    : () async {
                        if (!notifier.isAllShipiingSelected) {
                          GeneralModal.error(context,
                              msg:
                                  'There are still deliveries yet to be selected',
                              onOk: () {
                            Navigator.pop(context);
                          });
                          return;
                        }
                        if (notifier.paymentMethod == null) {
                          GeneralModal.error(context,
                              msg: 'Selected first payment method', onOk: () {
                            Navigator.pop(context);
                          });
                          return;
                        }
                        try {
                          final payment = await context
                              .read<ShopCheckoutProvider>()
                              .checkout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()),
                                (route) => false);
                            Navigator.push(context,
                                ShopPaymentPage.go(payment: payment.payments));
                          }
                        } on DioError catch (e) {
                          GeneralModal.error(context,
                              msg: e.response?.data['message'].toString() ??
                                  '-', onOk: () {
                            Navigator.pop(context);
                          });
                        } catch (e) {
                          GeneralModal.error(context, msg: e.toString(),
                              onOk: () {
                            Navigator.pop(context);
                          });
                        }
                      },
                child: const Text('Checkout')),
          ),
          const SizedBox(
            height: 32,
          )
        ],
      );
    });
  }
}
