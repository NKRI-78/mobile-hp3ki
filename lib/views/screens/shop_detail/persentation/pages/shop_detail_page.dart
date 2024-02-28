import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/modal.dart';
import 'package:hp3ki/views/screens/product_reviews/persentation/pages/product_reviews_page.dart';
import 'package:hp3ki/views/screens/shop_cart/persentation/pages/shop_cart_page.dart';
import 'package:hp3ki/views/screens/shop_cart/persentation/providers/shop_cart_provider.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/pages/shop_checkout_page.dart';
import 'package:hp3ki/views/screens/shop_detail/domain/shop_detail_repository.dart';
import 'package:hp3ki/views/screens/shop_detail/persentation/providers/shop_detail_provider.dart';
import 'package:hp3ki/widgets/loading_modal.dart';
import 'package:hp3ki/widgets/my_separator.dart';
import 'package:provider/provider.dart';

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({super.key, required this.id});

  static Route route(String id) {
    return MaterialPageRoute(
      builder: (_) => ShopDetailPage(
        id: id,
      ),
    );
  }

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ShopDetailProvider(
          id: id,
          repo: ShopDetailRepository(
            client: DioManager.shared.getClient(),
          ),
        )..fetchProductDetail(),
      )
    ], child: const ShopDetailView());
  }
}

class ShopDetailView extends StatelessWidget {
  const ShopDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopDetailProvider>(builder: (context, provider, child) {
      if (provider.loading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }
      if (provider.error.isNotEmpty) {
        return const Scaffold(
            body: SizedBox.expand(
          child: Center(
            child: Text('No Connection'),
          ),
        ));
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detil Produk',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ShopCartProvider>(builder: (context, notifier, child) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        ShopCartPage.go(),
                      );
                    },
                    child: Badge(
                      alignment: Alignment.topRight,
                      isLabelVisible: notifier.total == 0 ? false : true,
                      label: Text(notifier.total.toString()),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  width: 8,
                )
              ],
            )
          ],
        ),
        bottomNavigationBar: Consumer<ShopCartProvider>(
            builder: (context, cartProvider, child) =>
                Consumer<ProfileProvider>(builder: (_, profileNotifier, child) {
                  // final cart = provider.hasCart(cartProvider.carts);
                  // if (cart != null) {
                  //   return Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text((cart.cart.quantity).toString()),
                  //     ],
                  //   );
                  // }

                  if (provider.loading) return const SizedBox.shrink();
                  if (provider.product?.store.id ==
                      profileNotifier.user?.storeId) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200, width: 2),
                      ),
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom * .5),
                    height: 60,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton.icon(
                              onPressed: provider.loadingCart
                                  ? null
                                  : () {
                                      if ((provider.product?.stock ?? 0) <
                                          (provider.product?.minOrder ?? 0)) {
                                        GeneralModal.error(context,
                                            msg: 'Stok kurang');
                                        return;
                                      }
                                      context
                                          .read<ShopDetailProvider>()
                                          .addToCart();
                                    },
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                              ),
                              label: FittedBox(
                                child: Text(
                                  getTranslated("TXT_ADD_TO_CART", context),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.loadingCart
                                ? null
                                : () async {
                                    if ((provider.product?.stock ?? 0) <
                                        (provider.product?.minOrder ?? 0)) {
                                      GeneralModal.error(context,
                                          msg: 'Stok kurang');
                                      return;
                                    }
                                    await LoadingModalWidget.show(
                                      context,
                                      onInit: (ctx) async {
                                        await context
                                            .read<ShopDetailProvider>()
                                            .addBuyNow();
                                        if (!ctx.mounted) return;
                                        Navigator.pop(ctx);
                                      },
                                    );
                                    if (!context.mounted) return;
                                    Navigator.push(
                                      context,
                                      ShopCheckoutPage.go(
                                        ShopCheckoutType.now,
                                      ),
                                    );
                                  },
                            child: Text(
                              getTranslated(
                                "TXT_BUY_NOW",
                                context,
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  );
                })),
        body: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      height: MediaQuery.sizeOf(context).height * .45,
                      child: Stack(
                        children: [
                          if (provider.product?.pictures.isEmpty ?? true)
                            const SafeArea(
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                ),
                              ),
                            )
                          else ...[
                            Positioned.fill(
                              child: PageView(
                                controller: provider.pageController,
                                onPageChanged: (value) {
                                  context
                                      .read<ShopDetailProvider>()
                                      .onChangedPage(value);
                                },
                                children: provider.product?.pictures
                                        .map(
                                          (picture) => Image.network(
                                            picture.path,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        .toList() ??
                                    [],
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  provider.product?.pictures.length ?? 0,
                                  (index) => Container(
                                    height:
                                        index == provider.indexPage ? 12 : 10,
                                    width:
                                        index == provider.indexPage ? 12 : 10,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: index == provider.indexPage
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(
                                          index == provider.indexPage ? 6 : 5),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyTextInputFormatter(
                              locale: 'id_ID',
                              decimalDigits: 0,
                              symbol: 'Rp ',
                            ).format(
                              provider.product?.price.toString() ?? '0',
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            provider.product?.name ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            maxLines: 2,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  ProductReviewsPage.go(
                                      provider.product?.id ?? '-'));
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(provider.product?.review.rating ?? ""),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Ulasan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OverflowBox(
                                maxWidth: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  thickness: 3,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.grey.shade200,
                                ),
                                height: 50,
                                width: 50,
                                child: provider.product?.store.picture ==
                                            null ||
                                        provider.product?.store.picture == '-'
                                    ? const Icon(Icons.store)
                                    : Image.network(
                                        provider.product!.store.picture,
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
                                      provider.product?.store.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      provider.product?.store.city ?? '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IntrinsicHeight(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OverflowBox(
                                maxWidth: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  thickness: 3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detail ${getTranslated(
                                    "TXT_PRODUCT",
                                    context,
                                  )}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(
                                        "TXT_STOCK",
                                        context,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      (provider.product?.stock ?? 0).toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: MySeparator(
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(
                                        "TXT_WEIGHT",
                                        context,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (provider.product?.weight ?? 0)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          ' gr',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: MySeparator(
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(
                                        "TXT_CONDITION",
                                        context,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      provider.product?.condition.name ?? '-',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: MySeparator(
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(
                                        "TXT_MIN_ORDER",
                                        context,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      (provider.product?.minOrder ?? 0)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OverflowBox(
                                maxWidth: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  thickness: 3,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Description ${getTranslated("TXT_PRODUCT", context)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            provider.product?.description ?? '-',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
