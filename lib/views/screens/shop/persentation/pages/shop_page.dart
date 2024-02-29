import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/my_store/persentation/pages/my_store_page.dart';
import 'package:hp3ki/views/screens/my_store_create/persentation/pages/store_open_page.dart';
import 'package:hp3ki/views/screens/shop/data/models/shop.dart';
import 'package:hp3ki/views/screens/shop/domain/shop_repository.dart';
import 'package:hp3ki/views/screens/shop/persentation/providers/shop_provider.dart';
import 'package:hp3ki/views/screens/shop_cart/persentation/pages/shop_cart_page.dart';
import 'package:hp3ki/views/screens/shop_detail/persentation/pages/shop_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopPage extends StatelessWidget {
  static const route = '/shop';

  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ShopProvider(
          repo: ShopRepository(
            client: DioManager.shared.getClient(),
          ),
        )..init(),
      )
    ], child: const ShopView());
  }
}

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(builder: (context, provider, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Market'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, ShopCartPage.go());
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              Consumer<PPOBProvider>(builder: (context, ppob, child) {
                return Consumer<ProfileProvider>(
                    builder: (context, notifier, child) {
                  bool hasStore = notifier.user?.storeId != null;
                  return IconButton(
                    onPressed: () {
                      if (!hasStore) {
                        // if ((ppob.balance ?? 0) <= 20000) {
                        //   GeneralModal.error(context,
                        //       msg: getTranslated(
                        //           "TXT_OPEN_STORE_MINIM_WALLET", context),
                        //       onOk: () {
                        //     Navigator.pop(context);
                        //     NS.push(
                        //         context,
                        //         ConfirmPaymentV2(
                        //           accountNumber: SharedPrefs.getUserPhone(),
                        //           description: 'Isi Saldo sebesar Rp 20.000',
                        //           price: 20000,
                        //           adminFee: 6500,
                        //           productId:
                        //               "17805178-2f32-48a3-aab3-ce7a55eb3227",
                        //           provider: 'asdasd',
                        //           productName: 'Saldo',
                        //           type: "topup",
                        //         ));
                        //   });
                        //   return;
                        // }
                        NS.push(context, const StoreOpenPage());
                      } else {
                        NS.push(context, const MyStorePage());
                      }
                    },
                    icon: const Icon(Icons.store),
                  );
                });
              })
            ],
          ),
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: provider.categories
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: InkWell(
                                        onTap: () {
                                          context
                                              .read<ShopProvider>()
                                              .changeCategory(e.type);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: e.type == provider.category
                                                ? ColorResources.primary
                                                : Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: Text(
                                            e.name.toUpperCase(),
                                            style: TextStyle(
                                              color: e.type == provider.category
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight:
                                                  e.type == provider.category
                                                      ? FontWeight.bold
                                                      : FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SmartRefresher(
                      controller: provider.refreshController,
                      onRefresh: () {
                        context.read<ShopProvider>().fetchProductList();
                      },
                      enablePullUp: provider.currentPage != provider.nextPage,
                      onLoading: () {
                        context
                            .read<ShopProvider>()
                            .fetchProductList(loadMore: true);
                      },
                      child: SingleChildScrollView(
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: List.generate(
                            provider.shop?.total ?? 0,
                            (index) => StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: card(provider.shop!, index, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  Widget card(ShopModel shop, int index, context) {
    final product = shop.data[index];
    return InkWell(
      onTap: () {
        Navigator.push(context, ShopDetailPage.route(product.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  4,
                )),
            height: 160,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            child: product.picture == '-'
                ? const Center(
                    child: Icon(
                      Icons.image,
                      size: 80,
                    ),
                  )
                : Image.network(
                    product.picture,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            product.name,
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            CurrencyTextInputFormatter(
              locale: 'id_ID',
              decimalDigits: 0,
              symbol: 'Rp ',
            ).format(
              product.price.toString(),
            ),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 18,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(product.review.rating),
            ],
          )
        ],
      ),
    );
  }
}
