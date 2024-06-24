import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/views/screens/shipping_address/persentation/pages/shipping_address_page.dart';
import 'package:hp3ki/views/screens/shipping_address/persentation/providers/shipping_address_provider.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:hp3ki/widgets/custom_select_map_location.dart';
import 'package:provider/provider.dart';

class CheckoutShippingAddress extends StatelessWidget {
  const CheckoutShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShippingAddressProvider>(
        builder: (context, notifier, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(
                    "TXT_SHIPPING_ADDRESS",
                    context,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final addressOld =
                        context.read<ShippingAddressProvider>().primaryAddress;
                    await Navigator.push(context, ShippingAddressPage.go());
                    if (context.mounted) {
                      final addressNew = context
                          .read<ShippingAddressProvider>()
                          .primaryAddress;
                      if (addressOld?.postalCode != addressNew?.postalCode) {
                        context
                            .read<ShopCheckoutProvider>()
                            .removeAllDeliverySelect();
                      }
                    }
                  },
                  child: Text(
                    getTranslated(
                      "TXT_CHOOSE_ADDRESS",
                      context,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 3,
            thickness: 6,
            color: Colors.grey.shade200,
          ),
          if (notifier.primaryAddress != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifier.primaryAddress!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder(
                    future: geocodeParsing(
                      LatLng(
                        double.parse(notifier.primaryAddress!.lat),
                        double.parse(notifier.primaryAddress!.lng),
                      ),
                    ),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(
                      "TXT_ADDRESS_NOT_CHOOSE",
                      context,
                    ),
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
