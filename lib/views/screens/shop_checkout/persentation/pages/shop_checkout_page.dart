import 'package:flutter/material.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/shop_checkout/domain/shop_checkout_repository.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/providers/shop_checkout_provider.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/widgets/button_checkout.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/widgets/payment_options.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/widgets/product_checkout_widget.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/widgets/shipping_address.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/widgets/summary_checkout.dart';
import 'package:provider/provider.dart';

enum ShopCheckoutType { cart, now }

class ShopCheckoutPage extends StatelessWidget {
  const ShopCheckoutPage({
    super.key,
    required this.type,
  });

  final ShopCheckoutType type;

  static Route go(ShopCheckoutType type) => MaterialPageRoute(
        builder: (_) => ShopCheckoutPage(
          type: type,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShopCheckoutProvider>(
          create: (_) => ShopCheckoutProvider(
            type: type,
            repo: ShopCheckoutRepository(
              client: DioManager.shared.getClient(),
            ),
          )..init(),
        )
      ],
      child: const ShopCheckoutView(),
    );
  }
}

class ShopCheckoutView extends StatelessWidget {
  const ShopCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: const SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckoutShippingAddress(),
              ProductCheckoutWidget(),
              SummaryCheckout(),
              PaymentOptions(),
              ButtonCheckout(),
            ],
          ),
        ),
      ),
    );
  }
}
