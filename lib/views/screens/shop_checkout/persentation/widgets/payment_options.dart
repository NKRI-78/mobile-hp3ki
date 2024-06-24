import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:hp3ki/widgets/select_payment_option_widget.dart';
import 'package:provider/provider.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCheckoutProvider>(builder: (context, notif, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(
                    "TXT_PAYMENT_OPTIONS",
                    context,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final payment =
                        await SelectPaymentOptionWidget.showDialog(context);
                    if (payment != null && context.mounted) {
                      context
                          .read<ShopCheckoutProvider>()
                          .setPaymentMethod(payment);
                    }
                  },
                  child: notif.paymentMethod == null
                      ? const Text(
                          'Select Payment',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      : ListTile(
                          leading: Image.network(
                            notif.paymentMethod!.paymentLogo,
                            width: 50,
                          ),
                          title: Text(
                            notif.paymentMethod!.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                )
              ],
            ),
          ),
          Divider(
            height: 3,
            thickness: 6,
            color: Colors.grey.shade200,
          ),
        ],
      );
    });
  }
}
