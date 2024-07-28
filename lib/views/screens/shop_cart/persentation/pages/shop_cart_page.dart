import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/views/screens/shop_cart/data/models/shop_cart.dart';

import 'package:hp3ki/views/screens/shop_cart/persentation/providers/shop_cart_provider.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/pages/shop_checkout_page.dart';
import 'package:provider/provider.dart';

class ShopCartPage extends StatelessWidget {
  const ShopCartPage({super.key});

  static Route go() {
    return MaterialPageRoute(builder: (_) => const ShopCartPage());
  }

  @override
  Widget build(BuildContext context) {
    return const ShopCartView();
  }
}

class ShopCartView extends StatelessWidget {
  const ShopCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopCartProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(
            'TXT_CART',
            context,
          )),
        ),
        body: provider.loading
            ? _loadingBody
            : provider.error.isNotEmpty
                ? _errorBody
                : _body(context, provider),
      );
    });
  }

  Widget get _loadingBody => const Center(
        child: CircularProgressIndicator.adaptive(),
      );

  Widget get _errorBody => const Center(
        child: Text('Network Error'),
      );

  Widget _body(BuildContext context, ShopCartProvider provider) {
    return SizedBox.expand(
      child: Column(
        children: [
          if (provider.carts?.totalItem == 0)
            const Expanded(
              child: Center(
                child: Text('No carts'),
              ),
            )
          else
            Expanded(
                child: ListView(
              children:
                  List.generate(provider.carts?.stores.length ?? 0, (index) {
                final store = provider.carts!.stores[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.store.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ...List.generate(store.items.length, (ii) {
                            final item = store.items[ii];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox.adaptive(
                                      value: item.cart.selected,
                                      onChanged: (value) {
                                        context
                                            .read<ShopCartProvider>()
                                            .cartSelected(item.cart.id,
                                                type: 'none', selected: value);
                                      }),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(
                                        6,
                                      ),
                                    ),
                                    child: item.picture == '-'
                                        ? const Center(
                                            child: Icon(Icons.image),
                                          )
                                        : Image.network(
                                            item.picture,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          Helper.formatCurrency(
                                            item.price.toDouble(),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InputQuantity(item: item)
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<ShopCartProvider>()
                                          .deleteItem(item.cart.id);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Divider(
                      height: 4,
                      color: Colors.grey.shade100,
                      thickness: 8,
                    )
                  ],
                );
              }),
            )),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Text(
                  //   CurrencyTextInputFormatter(
                  //     locale: 'id_ID',
                  //     decimalDigits: 0,
                  //     symbol: 'Rp ',
                  //   ).format(
                  //     (provider.carts?.totalPrice ?? 0).toString(),
                  //   ),
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const Spacer(),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: provider.carts?.totalItem == 0
                          ? null
                          : () {
                              Navigator.push(context,
                                  ShopCheckoutPage.go(ShopCheckoutType.cart));
                            },
                      child: const Text('Checkout'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InputQuantity extends StatefulWidget {
  const InputQuantity({super.key, required this.item});

  final Item item;

  @override
  State<InputQuantity> createState() => _InputQuantityState();
}

class _InputQuantityState extends State<InputQuantity> {
  TextEditingController qty = TextEditingController();

  int minOrder = 0;
  int stock = 0;
  @override
  void initState() {
    super.initState();

    qty = TextEditingController(
      text: widget.item.cart.quantity.toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        minOrder = widget.item.minOrder;
        stock = widget.item.stock;
      });
    });
  }

  void addQty() {
    if (int.parse(qty.text) >= stock) return;
    qty.text = (int.parse(qty.text) + 1).toString();
    context
        .read<ShopCartProvider>()
        .updateQuantity(widget.item.cart.id, int.parse(qty.text));
  }

  void removeQty() {
    if (int.parse(qty.text) <= minOrder) {
      // context.read<ShopCartProvider>().deleteItem(widget.item.cart.id);
      return;
    }
    if (int.parse(qty.text) == 1) {
      context.read<ShopCartProvider>().deleteItem(widget.item.cart.id);
      return;
    }
    qty.text = (int.parse(qty.text) - 1).toString();
    context
        .read<ShopCartProvider>()
        .updateQuantity(widget.item.cart.id, int.parse(qty.text));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(onTap: removeQty, child: const Icon(Icons.remove)),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(minWidth: 35, maxHeight: 30),
            child: IntrinsicWidth(
              child: TextFormField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    qty.text = '1';
                    context.read<ShopCartProvider>().updateQuantity(
                        widget.item.cart.id, int.parse(qty.text));
                    return;
                  }
                  if (int.parse(qty.text) <= minOrder) {
                    qty.text = minOrder.toString();
                  } else if (int.parse(qty.text) >= stock) {
                    qty.text = stock.toString();
                  }
                  context
                      .read<ShopCartProvider>()
                      .updateQuantity(widget.item.cart.id, int.parse(qty.text));
                },
                controller: qty,
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        InkWell(onTap: addQty, child: const Icon(Icons.add)),
      ],
    );
  }
}
