import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:hp3ki/widgets/my_separator.dart';
import 'package:provider/provider.dart';

class SummaryCheckout extends StatelessWidget {
  const SummaryCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCheckoutProvider>(builder: (context, notifier, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated("TXT_SHOPPING_SUMMARY", context),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Harga (${notifier.totalItem} barang)',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(
                        notifier.totalPrice.toDouble(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total ongkos kirim',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(
                        notifier.totalShippingPrice.toDouble(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (notifier.paymentMethod != null)
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Biaya lainnya',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        Helper.formatCurrency(
                          notifier.paymentMethod!.totalAdminFee.toDouble(),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 8,
                ),
                const MySeparator(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      Helper.formatCurrency(
                        ((notifier.paymentMethod?.totalAdminFee ?? 0) +
                                notifier.totalPrice +
                                notifier.totalShippingPrice)
                            .toDouble(),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
